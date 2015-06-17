# This helper provides SOAP function to manipulate with Backend
# Service of http://wsf.cdyne.com/WeatherWS/Weather.asmx
# Function of backend service will be used is [GetCityForecastByZIP]

require 'sinatra/base'
require 'savon'

module Sinatra
    module SoapHelpers

        # SOAP function to get city forecast by zip code
        # @param zip [String] the city zip code
        # @return [Hash] response data
        def get_city_forecast_by_zip_soap (zip)
            client = Savon.client(log:true, 
                                  pretty_print_xml: true,
                                  wsdl: 'http://wsf.cdyne.com/WeatherWS/Weather.asmx?WSDL')
            client.operations
            response_data = client.call(:get_city_forecast_by_zip,
                                        :message => {'tns:ZIP' => zip})
            response_data.body
        end
    end
    
    helpers SoapHelpers
end