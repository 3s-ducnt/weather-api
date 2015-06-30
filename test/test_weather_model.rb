# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require 'minitest/autorun'	#getMinitest
require 'test/unit'
require 'rack/test'
require 'nokogiri'
require './config/initializers/load_config'
require './config/dm_config'

class TestWeatherModel < Test::Unit::TestCase
    include Rack::Test::Methods
    
    # Test create weather data in DB
    # @return Failure unless data insert not true format
    def test_create_weather_is_success
        doc =  Nokogiri.XML('
            <xml>
                <WeatherID>2</WeatherID>                
                <Desciption>Partly Cloudy</Desciption>
            </xml>
        ')
        old_count = Weather.count
        weather = Weather.create_weather doc
        new_count = Weather.count
        assert_equal weather.id, 2
        assert_equal weather.description, "Partly Cloudy"
        assert_compare(old_count, "<", new_count)
    end
    
    # (@see #test_create_weather_is_success)
    def test_create_weather_is_failure
        doc =  Nokogiri.XML('<xml></xml>')
        old_count = Weather.count
        weather = Weather.create_weather doc
        new_count = Weather.count
        assert_equal weather.id, ""
        assert_equal weather.description, ""
        assert_same old_count, new_count
    end
end