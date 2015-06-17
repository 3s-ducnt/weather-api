# DB Helper provides CRUD functions to manipulate with Weather API DB
# Tables: cities, weather_forecasts, weathers

require 'sinatra/base'
require 'nokogiri'
require 'dm-transactions'

module Sinatra
    module DbHelpers

        # Find weather forecast of city by zip code
        # @param zip [String] the City zip code
        # @return [City] the City forecast result
        def find_weather_by_zip (zip)
            City.first(zip_code: zip)
        end
        
        # Create city data in DB
        # @param doc [String] XML response data from Weather backend service
        # @return [City] the newly created Resource instance
        def create_city (doc)
            City.create(build_city(doc))
        end
        
        # Create weather master data in DB
        # @param doc [String] XML response data from Weather backend service
        # @return [Weather] the newly created Resource instance
        def create_weather (doc)
            Weather.create(build_weather(doc))
        end
        
        # Create weather forecast in DB
        # @param doc [String] XML response data from Weather backend service
        # @param city_id [Integer] city id
        # @return [WeatherForecast] last resource
        def create_weather_forecast (doc, city_id)
            forcasts = doc.css("Forecast")
            forcasts.each do |forecast|
                # insert weather data
                weather = Weather.get(forecast.css("WeatherID").text)
                
                weather = Weather.create(build_weather(forecast)) if !weather
                
                # insert weather forecast data
                WeatherForecast.create(build_weather_forecast(forecast, 
                                                              city_id,
                                                              weather.id))
            end
        end
        
        # Get weather data by zip code
        # @param zip [String] response data from Weather backend service
        # @return [Hash] weather data
        def get_weather_forecast (zip)
            #call create_city, create_weather_forecast method
            return_message = {}
            city = find_weather_by_zip(zip)
            if city
                # weather forecast data existed in DB then return data to client
                return_message[:status] = 'success'
                return_message[:data] = Array['city' => city]
                weather_forecasts = city.weather_forecasts.all()
                i = 1
                weather_forecasts.each do |forecast|
                    return_message[:data].push("forecast_day#{i}" => forecast)
                    return_message[:data].push("weather_day#{i}" => forecast.weather)
                    i += 1
                end
            end
            return_message
        end
        
        # Create weather data include: City, WeatherForeCast, Weather
        # @param doc [String] XML response data from Weather backend service
        # @return [Boolean] true if create success, false if create failed
        def create_weather_data (doc)
            City.transaction do
                # insert city data to cities table
                new_city = create_city(doc)

                logger.info("City has just created with city id is #{new_city.id}")

                # insert weather forecast to DB
                create_weather_forecast(doc, new_city.id)
            end
        end
        
        # Update city data in DB
        # Demo to update some attribute not all
        # @param response [Hash] response data from Weather backend service
        # @return [Boolean] true if update success, false if update failed
        def update_city (response)
            city = City.first(city: response[:city])
           
            city.update(:weather_station_city => response[:weather_station_city],
                        :updated => Time.now.strftime("%Y/%m/%d %H:%M:%S")
                        ) if city
        end
        
        # Update weather forecast data in DB
        # Demo to update some attributes not all
        # @param response [Hash] response data from Weather backend service
        # @return [Boolean] true if update success, false if update failed
        def update_weather_forecast (response)
            response[:forecast_result][:forecast].each do |forecast|
                # update weather forecast data
                weather_forecast = WeatherForecast.first(date: 
                                            forecast[:date].strftime('%Y-%m-%d'))
                weather_forecast.update(:temp_morning_low =>  
                                    forecast[:temperatures][:morning_low],
                                    :updated => Time.now.strftime("%Y/%m/%d %H:%M:%S")
                                    ) if weather_forecast
                                        
            end
        end
        
        # (@see #create_weather_data)
        def update_weather_data (response)
           City.transaction do
                # update city data to DB
                update_city(response)

                # update weather forecast to DB
                update_weather_forecast(response)
            end
        end
        
    end
    
    helpers DbHelpers
end