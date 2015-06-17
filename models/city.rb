# City model store city information
# City has [one to many] relation ship with WeatherForecast model

class City
    include DataMapper::Resource
    property :id, Serial
    property :zip_code, String
    property :weather_station_city, String
    property :city, String
    property :state, String
    property :created, DateTime
    property :updated, DateTime
  
    has n, :weather_forecasts  # each city has many forecast data
end
