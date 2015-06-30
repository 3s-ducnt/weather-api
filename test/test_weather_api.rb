# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require 'minitest/autorun'	#getMinitest
require 'test/unit'
require 'rack/test'
require './app/controllers/weather_api'

class TestWeatherApi < Test::Unit::TestCase
    include Rack::Test::Methods 
    def app
        WeatherApi
    end
    
    #Test Homepage
    # Failure unless body content not include str
    def test_displays_main_page_is_success
        str = "API"
        get "/"
        assert_include last_response.body, str
    end
    
    # (@see #test_displays_main_page_is_success)
    def test_displays_main_page_is_failure
        str = "Hello"
        get "/"
        assert_not_include last_response.body, str
    end
    
    #Test API
    # Success if JSON data have status is success
    def test_get_weather_forecast_by_zip_is_success
        zip = 94304
        get "/GetWeatherForecastByZip/#{zip}" 
        response = JSON.parse(last_response.body)
        assert_include response["status"],"success"
    end
    
    #Test API
    # Failure if JSON data have status is failed
    def test_get_weather_forecast_by_zip_is_failure
        zip = 39999
        get "/GetWeatherForecastByZip/#{zip}" 
        response = JSON.parse(last_response.body)
        assert_include response["status"],"failed"
    end
end