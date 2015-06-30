# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require 'minitest/autorun'	#getMinitest
require 'test/unit'
require 'rack/test'
require './config/initializers/load_config'
require './app/services/soap_service'

class TestSoapService < Test::Unit::TestCase
    include Rack::Test::Methods
    
    # Test get city forecast by zip code in SOAP
    # Failure unless return SOAP data not include key :forecast_result
    def test_get_city_forecast_by_zip_soap_is_success
        zip = '94304'
        soap_data = SoapService.get_city_forecast_by_zip_soap(zip)
        assert_include(soap_data, :forecast_result)
    end
    
    # (@see #test_get_city_forecast_by_zip_soap_is_success)
    def test_get_city_forecast_by_zip_soap_is_failure
        zip = '39999'
        soap_data = SoapService.get_city_forecast_by_zip_soap(zip)
        assert_not_include(soap_data, :forecast_result)
    end
end
