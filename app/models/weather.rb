# Master weather model contains all weather information
# Weather has [one to many] relation ship with WeatherForecast model

class Weather
    include DataMapper::Resource
    property :id, Integer, :key => true
    property :description, String
    
    has n, :weather_forecasts # each weather has many weather forecast
    
    class << self
        # Create weather master data in DB
        # @param doc [String] XML response data from Weather backend service
        # @return [Weather] the newly created Resource instance
        def create_weather (doc)
            Weather.create(build_weather(doc))
        end

        # Build weather data as Hash
        # @param forecast [XML node] the node to get
        # @return weather data (Hash)
        def build_weather (forecast)
            weather = {}
            keys_map = {
                "id" => "WeatherID",
                "description" => "Desciption"
            }
            keys_map.each do |key, value|
                weather[key] = forecast.css(value).text
            end
            weather
        end
    end
end
