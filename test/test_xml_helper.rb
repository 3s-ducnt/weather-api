# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require 'minitest/autorun'	#getMinitest
require 'test/unit'
require 'rack/test'
require './helpers/init'

class TestXmlHelper < Test::Unit::TestCase
    include Rack::Test::Methods
    include Sinatra::XmlHelpers
    
    # Test build City data as Hash
    # Failure unless hash value different xml document
    def test_build_city
        zip = '94304'
        doc =  Nokogiri.XML("            
            <xml>
                <State>CA</State>                
                <City>Palo Alto</City>                
                <WeatherStationCity>Mountain View</WeatherStationCity>            
            </xml>
        ")
        city = build_city(doc, zip)
        assert_equal city["state"],"CA"
        assert_equal city["city"],"Palo Alto"
        assert_equal city["weather_station_city"],"Mountain View"
    end
    
    # Test build weather data as Hash
    # Failure unless hash value different xml document
    def test_build_weather
        doc =  Nokogiri.XML('
            <xml>
                <WeatherID>3</WeatherID>                
                <Desciption>Partly Cloudy</Desciption>
            </xml>
        ')
        weather = build_weather(doc)
        assert_equal weather["id"],"3"
        assert_equal weather["description"],"Partly Cloudy"
    end
    
    # Test build Weather forecast data as Hash
    # Failure unless hash value different xml document
    def test_build_weather_forecast
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
        wf = build_weather_forecast(forecast, city_id, weather_id)
        assert_equal wf["date"],"2014-11-08T00:00:00"
        assert_equal wf["temp_morning_low"],"32"
        assert_equal wf["temp_day_time_high"],"50"
        assert_equal wf["precipiation_night_time"],"10"
        assert_equal wf["precipiation_day_time"],"00"
    end
    
    # Test check XML response data from backend service
    # Failure unless return response data is true
    def test_check_response_data
        doc = Nokogiri.XML('<Success>false</Success>')
        bools = check_response_data doc
        assert_false(bools[0])
    end
end

