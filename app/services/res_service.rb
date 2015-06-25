# This helper provides REST function to manipulate with Backend
# Service of http://wsf.cdyne.com/WeatherWS/Weather.asmx
# Function of backend service will be used is [GetCityForecastByZIP]

require 'rest-client'

class ResService
    class << self
        # REST function to get city forecast by zip code
        # @param zip [String] the city zip code
        # @return [String] XML response data
        def get_city_forecast_by_zip_res (zip)
            # Client request to weather service
            RestClient.get APP_CONFIG["rest_url"], {params: {ZIP: "#{zip}"}}
        end
    end
end
