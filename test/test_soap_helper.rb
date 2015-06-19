# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require 'minitest/autorun'	#getMinitest
require 'test/unit'
require 'rack/test'
require './helpers/init'

class TestSoapHelper < Test::Unit::TestCase
    include Rack::Test::Methods
    include Sinatra::SoapHelpers
    
    # Test get city forecast by zip code in SOAP
    # Failure unless return SOAP data exclude key :forecast_result
    def test_get_city_forecast_by_zip_soap
        zip = '94304'
        soap_data = get_city_forecast_by_zip_soap(zip)
        assert_include(soap_data, :forecast_result)
    end
end
