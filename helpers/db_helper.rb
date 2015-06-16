# DB Helper provides CRUD functions to manipulate with Weather API DB
# Tables: cities, weather_forecasts, weathers

require 'sinatra/base'

module Sinatra
    module DbHelpers

        # Find weather forecast of city by zip code
        # @param zip [String] the City zip code
        # @return [City] the City forecast result
        def find_weather_by_zip (zip)
            City.first(zip_code: zip)
        end
        
        # Create city data in DB
        # @param xml_data [String] XML response data from Weather backend service
        # @return [Boolean] true if success, false if register failed.
        def create_city (xml_data)
            
        end
        
        # Create weather forecast in DB
        # @param xml_data [String] XML response data from Weather backend service
        # @return [Boolean] true if success, false if register failed.
        def create_weather_forecast (xml_data)
            
        end
        
        # Method call create_city, create_weather_forecast method
        # @param xml_data [String] XML response data from Weather backend service
        # @return [Boolean] true if success, false if register failed.
        def create_weather_data (xml_data)
            #call create_city, create_weather_forecast method
            
        end
        
        # (see #create_city)
        def update_city (xml_data)
            
        end
        
        # (see #create_weather_forecast)
        def update_weather_forecast (xml_data)
            
        end
        
        # (see #create_weather_data)
        def update_weather_data (xml_data)
            
        end
    end
    
    helpers DbHelpers
end