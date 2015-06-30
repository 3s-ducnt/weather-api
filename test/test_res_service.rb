# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require 'minitest/autorun'	#getMinitest
require 'test/unit'
require 'rack/test'
require './config/initializers/load_config'
require './app/services/res_service'

class TestResService < Test::Unit::TestCase
    include Rack::Test::Methods
    
    # Test get city forecast by zip code in REST
    # Failure unless return REST data not include <ForecastResult>
    def test_get_city_forecast_by_zip_res_is_success
        zip = '94304'
        xml_data = ResService.get_city_forecast_by_zip_res (zip)
        assert_include(xml_data,"ForecastResult")
    end
    
    # (@see #test_get_city_forecast_by_zip_res_is_success)
    def test_get_city_forecast_by_zip_res_is_failure
        zip = '39999'
        xml_data = ResService.get_city_forecast_by_zip_res (zip)
        assert_not_include(xml_data, "ForecastResult")
    end
end
