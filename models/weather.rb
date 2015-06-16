# Master weather model contains all weather information

class Weather
    include DataMapper::Resource
    property :id, Serial
    property :description, String
    property :image_url, String
end
