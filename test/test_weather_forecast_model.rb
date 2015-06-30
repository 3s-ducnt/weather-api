# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require 'minitest/autorun'	#getMinitest
require 'test/unit'
require 'rack/test'
require 'nokogiri'
require './config/initializers/load_config'
require './config/dm_config'

class TestWeatherForecastModel < Test::Unit::TestCase
    include Rack::Test::Methods
    
    # Test build Weather forecast data as Hash
    # Failure unless hash value different xml document
    def test_build_weather_forecast_is_success
        city_id = 1
        weather_id = 4
        forecast =  Nokogiri.XML('
            <Forecast>
                <Date>2014-11-08T00:00:00</Date>
                <Temperatures>
                    <MorningLow>32</MorningLow>
                    <DaytimeHigh>50</DaytimeHigh>
                </Temperatures>
                <ProbabilityOfPrecipiation>
                    <Nighttime>10</Nighttime>
                    <Daytime>00</Daytime>
                </ProbabilityOfPrecipiation>
            </Forecast>
            ')
        wf = WeatherForecast.build_weather_forecast(forecast, city_id, weather_id)
        assert_equal wf["city_id"],1
        assert_equal wf["weather_id"],4
        assert_equal wf["date"],"2014-11-08T00:00:00"
        assert_equal wf["temp_morning_low"],"32"
        assert_equal wf["temp_daytime_high"],"50"
        assert_equal wf["precipiation_night_time"],"10"
        assert_equal wf["precipiation_day_time"],"00"
    end
    
    def test_build_weather_forecast_is_failure
        city_id = 1
        weather_id = 4
        forecast =  Nokogiri.XML('
            <Forecast>
                <Dates>2014-11-08T00:00:00</Dates>
                <Temperatures>
                    <MorningLows>32</MorningLows>
                    <DaytimeHighs>50</DaytimeHighs>
                </Temperatures>
                <ProbabilityOfPrecipiation>
                    <Nighttimes>10</Nighttimes>
                    <Daytimes>00</Daytimes>
                </ProbabilityOfPrecipiation>
            </Forecast>
            ')
        wf = WeatherForecast.build_weather_forecast(forecast, city_id, weather_id)
        assert_equal wf["city_id"],1
        assert_equal wf["weather_id"],4
        assert_not_equal wf["date"],"2014-11-08T00:00:00"
        assert_not_equal wf["temp_morning_low"],"32"
        assert_not_equal wf["temp_daytime_high"],"50"
        assert_not_equal wf["precipiation_night_time"],"10"
        assert_not_equal wf["precipiation_day_time"],"00"
    end
end