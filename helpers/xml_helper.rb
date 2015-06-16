# Parse XML response from Weather backend service
# Build data for executing DB CRUD functions

require 'nokogiri'

module Sinatra
    module XmlHelpers
        
        # Build City data as Hash
        # @param doc [String] the document which is parsed from XML
        # @return city data (Hash)
        def build_city (doc)
            city = Hash.new("zip_code" => params[:zip])
            # prepare city data
            city["state"] = doc.css("State")
            city["city"] = doc.css("City")
            city["weather_station_city"] = doc.css("WeatherStationCity")
            city["created"], city["updated"] = Time.now.strftime("%m/%d/%Y")
            city
        end
        
        # Build Weather forecast data as Hash
        # @param forecast [String] the Forecast node which is parsed from XML
        # @return Weather forecast data (Hash)
        def build_weather_forecast (forecast, city_id)
            weather_forecast = Hash.new
            weather_forecast["date"] = forecast.css("Date")
            weather_forecast["weather_id"] = forecast.css("WeatherID")
            weather_forecast["temp_morning_low"] = forecast.css("Temperatures").childNodes.first
            weather_forecast["temp_day_time_high"] = forecast.css("Temperatures").childNodes.second
            weather_forecast["precipiation_night_time"] = forecast.css("ProbabilityOfPrecipiation").childNodes.first
            weather_forecast["precipiation_day_time"] = forecast.css("ProbabilityOfPrecipiation").childNodes.second
            weather_forecast["city_id"] = city_id
            weather_forecast
        end
    end
    
    helpers XmlHelpers
end
