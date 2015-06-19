# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require 'minitest/autorun'	#getMinitest
require 'test/unit'
require 'rack/test'
require './weather_api'

class TestWeatherApi < Test::Unit::TestCase
    include Rack::Test::Methods 
    def app
        WeatherApi
    end
    
    #Test Homepage
    # Failure unless body content exclude "API"
    def test_displays_main_page
        get "/"
        assert last_response.ok?
        assert last_response.body.include?("API")
    end
    
    #Test API
    # Failure unless JSON data have status is success
    def test_get_weather_forecast_by_zip
        zip = 94304
        get "/GetWeatherForecastByZip/#{zip}" 
        response = JSON.parse(last_response.body)
        assert response["status"].include?("success")
    end

end