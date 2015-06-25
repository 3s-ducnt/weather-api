# This helper provides SOAP function to manipulate with Backend
# Service of http://wsf.cdyne.com/WeatherWS/Weather.asmx
# Function of backend service will be used is [GetCityForecastByZIP]

require 'savon'

class SoapService
    class << self
        # SOAP function to get city forecast by zip code
        # @param zip [String] the city zip code
        # @return [Hash] response data
        def get_city_forecast_by_zip_soap (zip)

            # Prepare soap client
            client = Savon.client(log:true, 
                                  pretty_print_xml: true,
                                  wsdl: APP_CONFIG["soap_url"])
            client.operations
            response = client.call(:get_city_forecast_by_zip,
                                   message: {APP_CONFIG["zip_param"] => zip})
            response.to_hash[:get_city_forecast_by_zip_response][:get_city_forecast_by_zip_result]
        end
    end
end