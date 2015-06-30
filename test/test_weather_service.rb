# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require 'minitest/autorun'	#getMinitest
require 'test/unit'
require 'rack/test'
require './config/initializers/load_config'
require './config/dm_config'
require './app/services/res_service'
require './app/services/soap_service'
require './app/services/weather_service'

class TestDbHelper < Test::Unit::TestCase
    include Rack::Test::Methods
    
    def setup
        @zip  = '07114'
        @zip1 = '94304'
        @zip2 = '39999'
    end
    # Test get weather forecast by zip main processing
    # @return Failure if return message is empty
    def test_get_weather_forecast_by_zip_is_sucess
        City.create(:zip_code => '07114')
        return_message = WeatherService.get_weather_forecast(@zip)
        assert_not_empty return_message
    end
    
    # (@see #test_get_weather_forecast_by_zip_is_sucess)
    def test_get_weather_forecast_by_zip_is_failure
        return_message = WeatherService.get_weather_forecast(@zip2)
        assert_empty return_message
    end
    
    # Test get weather service by REST client
    # @return success if data was inserted to cities table and weather_forecasts table
    def test_get_weather_service_res_is_success
        WeatherService.get_weather_service_res(@zip1)
        city = City.first(zip_code: @zip1)
        assert_not_nil city
        assert_not_nil WeatherForecast.all(:city_id => city.id)
    end
    
    # Test get weather service by REST client
    # @return failure if print Standard Error
    def test_get_weather_service_res_is_failure
        err = assert_raise StandardError do
            WeatherService.get_weather_service_res(@zip2)
        end
        assert_match /could not be found/, err.message
    end
    
    # Test get weather service by SOAP client
    # @return success if data was updated to cities table and weather_forecasts table
    def test_get_weather_service_soap_is_success
        WeatherService.get_weather_service_soap(@zip1)
        city = City.first(zip_code: @zip1)
        weather_forecasts = WeatherForecast.all(:city_id => city.id)
        assert_not_equal city.created, city.updated
        weather_forecasts.each do |forecast|
            assert_not_equal forecast.created, forecast.updated
        end
    end
    
    # Test get weather service by SOAP client
    # @return failure if print Standard Error
    def test_get_weather_service_soap_is_failure
        err = assert_raise StandardError do
            WeatherService.get_weather_service_soap(@zip2)
        end
        assert_match /could not be found/, err.message
    end
end