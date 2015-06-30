# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require 'minitest/autorun'	#getMinitest
require 'test/unit'
require 'rack/test'
require 'nokogiri'
require './config/initializers/load_config'
require './config/dm_config'

class TestCityModel < Test::Unit::TestCase
    include Rack::Test::Methods
     
    # Test create city data in DB
    # @return Failure unless zip code not nil in data insert
    def test_create_city_is_success
        zip = '94304'
        doc =  Nokogiri.XML("            
            <xml>
                <State>CA</State>                
                <City>Palo Alto</City>                
                <WeatherStationCity>Mountain View</WeatherStationCity>            
            </xml>
        ")
        old_count = City.count
        city = City.create_city doc, zip
        new_count = City.count
        assert_equal city.zip_code, "94304" 
        assert_equal city.state, "CA" 
        assert_equal city.city, "Palo Alto"
        assert_equal city.weather_station_city, "Mountain View"
        assert_compare old_count, "<", new_count
    end
    
    # (@see #test_create_city_is_success)
    def test_create_city_is_failure
        zip = nil
        doc =  Nokogiri.XML("            
            <xml>
                <State>CA</State>                
                <City>Palo Alto</City>                
                <WeatherStationCity>Mountain View</WeatherStationCity>            
            </xml>
        ")
        old_count = City.count
        city = City.create_city doc, zip
        new_count = City.count
        assert_equal city.zip_code, nil
        assert_equal city.state, "CA" 
        assert_equal city.city, "Palo Alto"
        assert_equal city.weather_station_city, "Mountain View"
        assert_same old_count, new_count
    end
    
    # Test find weather forecast of city by zip code
    # @return Failure unless return data not nil
    def test_find_weather_by_zip_is_success
        zip = '94304'
        data = City.find_weather_by_zip (zip)
        assert_not_nil data
    end
    
    # (@see #test_find_weather_by_zip_is_success)
    def test_find_weather_by_zip_is_failure
        zip = '39999'
        data = City.find_weather_by_zip (zip)
        assert_nil data
    end
    
    # Test update city data in DB
    # Failure unless do not find data updated
    def test_update_city_is_success
        response = {:city=>"Palo Alto", :weather_station_city=>"Newark"}
        City.update_city response
        assert_not_nil(City.first(city: "Palo Alto", 
                                  weather_station_city: "Newark"))
    end
    
    # (@see #test_update_city_is_success)
    def test_update_city_is_failure
        response = {:city=>"Newark", :weather_station_city=>"Newark"}
        City.update_city response
        assert_nil(City.first(city: "Newark", 
                              weather_station_city: "Newark"))
    end
end
