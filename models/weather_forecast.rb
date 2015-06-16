# Weather forecast model to store forecast weather of a city by date

class WeatherForecast
    include DataMapper::Resource
    property :id, Serial
    property :temp_morning_low, Integer
    property :temp_day_time_high, Integer
    property :precipiation_night_time, Integer
    property :precipiation_day_time, Integer
    property :date, Date
    property :created, DateTime
    property :updated, DateTime

    belongs_to :city

end