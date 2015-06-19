# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require 'minitest/autorun'	#getMinitest
require 'test/unit'
require 'rack/test'
require './helpers/init'

class TestResHelper < Test::Unit::TestCase
    include Rack::Test::Methods
    include Sinatra::ResHelpers
    
    # Test get city forecast by zip code in REST
    # Failure unless return REST data exclude <ForecastResult>
    def test_get_city_forecast_by_zip_res
        zip = '94304'
        xml_data = get_city_forecast_by_zip_res (zip)
        assert xml_data.include?("ForecastResult")
    end
end
