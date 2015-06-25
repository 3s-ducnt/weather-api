# DB Helper provides CRUD functions to manipulate with Weather API DB
# Tables: cities, weather_forecasts, weathers

require 'nokogiri'
require 'dm-transactions'
require_relative './res_service'
require_relative './soap_service'

class WeatherService
    
    class << self
        
        # Get weather forecast by zip main processing
        # @param zip [String] the City zip code
        # @return return_message [Hash] return message if processing failed
        # weather data [Hash] if processing success
        def get_weather_forecast_by_zip (zip)
            return_message = get_weather_forecast(zip)

            return return_message if !return_message.empty?

            # Call RES service to create weather forecast data in DB
            get_weather_service_res (zip)
            
            # Call SOAP service to update weather forecast data in DB
            get_weather_service_soap (zip)
            
            # Get data from DB and return
            get_weather_forecast(zip)
        end

        # Get weather service by REST client
        # @param zip [String] the city zip code
        # @return return_message [Hash] if processing failed
        def get_weather_service_res (zip)
            # call REST API to get weather forecast by zip code
            doc = Nokogiri.XML(ResService.get_city_forecast_by_zip_res(zip))
            
            check_response_data(doc)
            
            # Register weather data into DB
            create_weather_data(doc, zip)
        end
        
        # Get weather service by SOAP client
        # @param zip [String] the city zip code
        # @return return_message [Hash] if processing failed
        def get_weather_service_soap (zip)
            # call SOAP API to get weather forecast by Zip code
            response = SoapService.get_city_forecast_by_zip_soap(zip)
            puts response
            check_response_data(nil, response)

            # Update weather data into DB
            update_weather_data(response)
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

                weather = Weather.create_weather (forecast) if !weather

                # insert weather forecast data
                WeatherForecast.create(WeatherForecast.build_weather_forecast(
                                                                forecast, 
                                                                city_id,
                                                                weather.id))
            end
        end

        # Get weather data by zip code
        # @param zip [String] response data from Weather backend service
        # @return [Hash] weather data
        def get_weather_forecast (zip)
            return_message = {}
            city = City.find_weather_by_zip(zip)
            if city
                # weather forecast data existed in DB then return data to client
                return_message[:status] = APP_CONFIG['success']
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
        def create_weather_data (doc, zip_code)
            City.transaction do
                # insert city data to cities table
                new_city = City.create_city(doc, zip_code)

                # insert weather forecast to DB
                create_weather_forecast(doc, new_city.id)
            end
        end

        # Update weather forecast data in DB
        # Demo to update some attributes not all
        # @param response [Hash] response data from Weather backend service
        # @return [Boolean] true if update success, false if update failed
        def update_weather_forecast (response)
            response[:forecast_result][:forecast].each do |forecast|
                # update weather forecast data
                weather_forecast = WeatherForecast.first(
                                    date: forecast[:date].strftime('%Y-%m-%d'))
                weather_forecast.update(
                                        temp_morning_low: forecast[:temperatures][:morning_low],
                                        updated: Time.now.strftime("%Y/%m/%d %H:%M:%S")
                                        ) if weather_forecast

            end
        end

        # (@see #create_weather_data)
        def update_weather_data (response)
           City.transaction do
                # update city data to DB
                City.update_city(response)

                # update weather forecast to DB
                update_weather_forecast(response)
            end
        end

        # Check XML response data from backend service
        # @param doc (optional) [String] XML data
        # @param hash_data (optional) [Hash] response data
        # @exception StandardError exception
        def check_response_data (doc = nil, hash_data = nil)
            if (doc != nil && doc.css("Success").text == "false") || 
                  (hash_data != nil && !hash_data[:success])
                raise StandardError, APP_CONFIG["city_not_found"]
            end
        end
    end
end
