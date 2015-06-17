# Master weather model contains all weather information
# Weather has [one to many] relation ship with WeatherForecast model

class Weather
    include DataMapper::Resource
    property :id, Integer, :key => true
    property :description, String
    property :image_url, String
    
    has n, :weather_forecasts # each weather has many weather forecast
end
