# Weather forecast model to store forecast weather of a city by date
# Weather forecast has [belongs to] relation ship with City, Weather model

require './lib/string'

class WeatherForecast
    include DataMapper::Resource
    property :id, Serial
    property :temp_morning_low, String
    property :temp_daytime_high, String
    property :precipiation_night_time, String
    property :precipiation_day_time, String
    property :date, Date
    property :created, DateTime
    property :updated, DateTime

    belongs_to :city   #each forecast data belongs to a city
    belongs_to :weather #each forecast data belongs to a weather
    
    class << self
        # Build Weather forecast data as Hash
        # @param forecast [String] the Forecast node which is parsed from XML
        # @param city_id [Integer] City ID
        # @param weather_id [Integer] Weather ID
        # @return Weather forecast data (Hash)
        def build_weather_forecast (forecast, city_id, weather_id)
            weather_forecast = {}
            keys_map = {
                "temp_morning_low" => "MorningLow",
                "temp_daytime_high" => "DaytimeHigh",
                "precipiation_night_time" => "Nighttime",
                "precipiation_day_time" => "Daytime",
                "date" => "Date"
            }
            keys_map.each do |key, value|
                weather_forecast[key] = forecast.css(value).text
            end
            # set other values
            weather_forecast["city_id"] = city_id
            weather_forecast["weather_id"] = weather_id
            weather_forecast["created"] = Time.now.strftime("%Y/%m/%d %H:%M:%S")
            weather_forecast["updated"] = Time.now.strftime("%Y/%m/%d %H:%M:%S")
            weather_forecast
        end
    
    end
        
end