# Parse XML response from Weather backend service
# Build data for executing DB CRUD functions

require 'nokogiri'

module Sinatra
    module XmlHelpers
        
        # Build City data as Hash
        # @param doc [String] the document which is parsed from XML
        # @param zip_code [String] City zip code
        # @return city data (Hash)
        def build_city (doc, zip_code)
            city = Hash.new
            # prepare city data
            city["zip_code"] = zip_code
            city["state"] = doc.css("State").text
            city["city"] = doc.css("City").text
            city["weather_station_city"] = doc.css("WeatherStationCity").text
            city["created"] = Time.now.strftime("%Y/%m/%d %H:%M:%S")
            city["updated"] = Time.now.strftime("%Y/%m/%d %H:%M:%S")
            city
        end
        
        # Build weather data as Hash
        # @param forecast [XML node] the node to get
        # @return weather data (Hash)
        def build_weather (forecast)
            weather = Hash.new
            weather["id"] = forecast.css("WeatherID").text
            weather["description"] = forecast.css("Desciption").text
            weather
        end
        
        # Build Weather forecast data as Hash
        # @param forecast [String] the Forecast node which is parsed from XML
        # @param city_id [Integer] City ID
        # @param weather_id [Integer] Weather ID
        # @return Weather forecast data (Hash)
        def build_weather_forecast (forecast, city_id, weather_id)
            weather_forecast = Hash.new
            weather_forecast["date"] = forecast.css("Date").text
            weather_forecast["temp_morning_low"] = forecast.css("MorningLow").text
            weather_forecast["temp_day_time_high"] = forecast.css("DaytimeHigh").text
            weather_forecast["precipiation_night_time"] = forecast.css("Nighttime").text
            weather_forecast["precipiation_day_time"] = forecast.css("Daytime").text
            weather_forecast["city_id"] = city_id
            weather_forecast["weather_id"] = weather_id
            weather_forecast["created"] = Time.now.strftime("%Y/%m/%d %H:%M:%S")
            weather_forecast["updated"] = Time.now.strftime("%Y/%m/%d %H:%M:%S")
            weather_forecast
        end
        
        # Check XML response data from backend service
        # @param doc (optional) [String] XML data
        # @param hash_data (optional) [Hash] response data
        # @return [Boolean], [Hash] return true if City found.
        # Return false and message if city not found
        def check_response_data (doc = nil, hash_data = nil)
            return_message = {}
            check = true
            if (doc != nil && doc.css("Success").text == "false") || 
                  (hash_data != nil && !hash_data[:success])
                check = false
                return_message[:status] = 'failed'
                return_message[:message] = 'City could not be found in our '\
                                           'weather data. Please contact CDYNE '\
                                           'for more Details.'
            end
            return check, return_message
        end
    end
    
    helpers XmlHelpers
end
