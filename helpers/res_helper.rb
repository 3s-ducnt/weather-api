# This helper provides REST function to manipulate with Backend
# Service of http://wsf.cdyne.com/WeatherWS/Weather.asmx
# Function of backend service will be used is [GetCityForecastByZIP]

require 'sinatra/base'
require 'rest-client'

module Sinatra
    module ResHelpers

        # REST function to get city forecast by zip code
        # @param zip [String] the city zip code
        # @return [String] XML response data
        def get_city_forecast_by_zip_res (zip)
            RestClient.get 'http://wsf.cdyne.com/WeatherWS/Weather.asmx/GetCityForecastByZIP', {:params => {:ZIP => "#{zip}"}}
        end
    end
    
    helpers ResHelpers
end
