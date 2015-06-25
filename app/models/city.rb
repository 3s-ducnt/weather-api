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
    
    class << self

        # Find weather forecast of city by zip code
        # @param zip [String] the City zip code
        # @return [City] the City forecast result
        def find_weather_by_zip (zip)
            City.first(zip_code: zip)
        end

        # Create city data in DB
        # @param doc [String] XML response data from Weather backend service
        # @param zip_code [String] City zip code
        # @return [City] the newly created Resource instance
        def create_city (doc, zip_code)
            City.create(build_city(doc, zip_code))
        end

        # Update city data in DB
        # Demo to update some attribute not all
        # @param response [Hash] response data from Weather backend service
        # @return [Boolean] true if update success, false if update failed
        def update_city (response)
            city = City.first(city: response[:city])

            city.update(weather_station_city: response[:weather_station_city],
                        updated: Time.now.strftime("%Y/%m/%d %H:%M:%S")
                        ) if city
        end

        # Build City data as Hash
        # @param doc [String] the document which is parsed from XML
        # @param zip_code [String] City zip code
        # @return city data (Hash)
        def build_city (doc, zip_code)
            city = {}
            keys_map = {
                "state" => "State",
                "city" => "City",
                "weather_station_city" => "WeatherStationCity"
            }
            # prepare city data
            keys_map.each do |key, value|
                city[key] = doc.css(value).text
            end
            # set other values
            city["zip_code"] = zip_code
            city["created"] = Time.now.strftime("%Y/%m/%d %H:%M:%S")
            city["updated"] = Time.now.strftime("%Y/%m/%d %H:%M:%S")
            city
        end
    end
end
