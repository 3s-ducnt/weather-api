# DB Helper provides CRUD functions to manipulate with Weather API DB
# Tables: cities, weather_forecasts, weathers

require 'sinatra/base'
require 'nokogiri'

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
        def get_weather_data (zip)
            #call create_city, create_weather_forecast method
            return_message = {}
            city = find_weather_by_zip(zip)
            if city
                # weather forecast data is existed in DB then return data to client
                return_message[:status] = 'success'
                return_message[:data] = Array['city' => city]
                weather_forecasts = city.weather_forecasts.all()
                i = 1
                weather_forecasts.each do |forecast|
                    return_message[:data].push("weather_forecast_day#{i}" => forecast)
                    return_message[:data].push("weather_day#{i}" => forecast.weather)
                    i += 1
                end
            end
            return_message
        end
        
        # (see #create_city)
        def update_city (doc)
            city = City.first(city: doc.css("City").text)
            city.update(build_city(doc))
        end
        
        # (see #create_weather_forecast)
        def update_weather_forecast (doc, city_id)
            forcasts = doc.css("Forecast")
            forcasts.each do |forecast|
                # insert weather data
                weather = Weather.get(forecast.css("WeatherID").text)
                
                weather = Weather.create(build_weather(forecast)) if !weather
                
                # insert weather forecast data
                weather_forecast = WeatherForecast.first(date: 
                                                   forecast.css("Date").text)
                weather_forecast.update(build_weather_forecast(forecast,
                                                                city_id,
                                                                weather.id))
            end
        end
        
        # (see #get_weather_data)
        def update_weather_data (xml_data)
            
        end
    end
    
    helpers DbHelpers
end