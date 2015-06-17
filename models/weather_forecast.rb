# Weather forecast model to store forecast weather of a city by date
# Weather forecast has [belongs to] relation ship with City, Weather model

class WeatherForecast
    include DataMapper::Resource
    property :id, Serial
    property :temp_morning_low, String
    property :temp_day_time_high, String
    property :precipiation_night_time, String
    property :precipiation_day_time, String
    property :date, Date
    property :created, DateTime
    property :updated, DateTime

    belongs_to :city   #each forecast data belongs to a city
    belongs_to :weather #each forecast data belongs to a weather

end