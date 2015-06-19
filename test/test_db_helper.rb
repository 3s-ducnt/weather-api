# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require 'minitest/autorun'	#getMinitest
require 'test/unit'
require 'rack/test'
require './helpers/init'
require './models/dm_config'
require 'dm-serializer'
require 'date'

class TestDbHelper < Test::Unit::TestCase
    include Rack::Test::Methods
    include Sinatra::DbHelpers
    include Sinatra::XmlHelpers
    include Sinatra::ResHelpers
    
    # Test find weather forecast of city by zip code
    # Failure unless do not find city zip code
    def test_find_weather_by_zip
        zip = '94304'
        city = find_weather_by_zip zip
        assert_equal '94304', city.zip_code
    end
    
    # Test create city data in DB
    # Failure unless count data do not increment
    def test_create_city
        zip = '94304'
        doc =  Nokogiri.XML("            
            <xml>
                <State>CA</State>                
                <City>Palo Alto</City>                
                <WeatherStationCity>Mountain View</WeatherStationCity>            
            </xml>
        ")
        old_count = City.count
        create_city doc, zip
        new_count = City.count
        assert_compare(old_count, "<", new_count)
    end
    
    # Test create weather data in DB
    # Failure unless count data do not increment
    def test_create_weather
        doc =  Nokogiri.XML('
            <xml>
                <WeatherID>3</WeatherID>                
                <Desciption>Partly Cloudy</Desciption>
            </xml>
        ')
        old_count = Weather.count
        create_weather doc
        new_count = Weather.count
        assert_compare(old_count, "<", new_count)
    end
    
    # Test create weather forecast data in DB
    # Failure unless count data do not increment
    def test_create_weather_forecast
        city_id = 1
        doc =  Nokogiri.XML('
            <xml>
                <Forecast>
                    <Date>2014-11-08T00:00:00</Date>
                    <WeatherID>4</WeatherID>
                    <Desciption>Sunny</Desciption>
                    <Temperatures>
                        <MorningLow>32</MorningLow>
                        <DaytimeHigh>50</DaytimeHigh>
                    </Temperatures>
                    <ProbabilityOfPrecipiation>
                        <Nighttime>10</Nighttime>
                        <Daytime>00</Daytime>
                    </ProbabilityOfPrecipiation>
                </Forecast>
                <Forecast>
                    <Date>2014-11-09T00:00:00</Date>
                    <WeatherID>2</WeatherID>
                    <Desciption>Partly Cloudy</Desciption>
                    <Temperatures>
                        <MorningLow>41</MorningLow>
                        <DaytimeHigh>53</DaytimeHigh>
                    </Temperatures>
                    <ProbabilityOfPrecipiation>
                        <Nighttime>20</Nighttime>
                        <Daytime>20</Daytime>
                    </ProbabilityOfPrecipiation>
                </Forecast>
            </xml>
            ')
        old_count = WeatherForecast.count
        create_weather_forecast doc,city_id
        new_count = WeatherForecast.count
        assert_compare(old_count, "<", new_count)
    end 
    
    # Test get weather data by zip code
    # Failure unless return message is empty
    def test_get_weather_forecast
        zip = '94304'
        return_message = get_weather_forecast zip
        assert_not_empty(return_message)
    end
    
    # Test create weather data include: City, WeatherForeCast, Weather
    # Failure unless count data do not increment
    def test_create_weather_data
        zip_code = '94304'
        doc = Nokogiri.XML(get_city_forecast_by_zip_res zip_code)
        
        old_count_city = City.count
        old_count_weather = Weather.count
        old_count_forecast = WeatherForecast.count
        create_weather_data doc, zip_code
        new_count_city = City.count
        new_count_weather = Weather.count
        new_count_forecast = WeatherForecast.count
        
        assert_compare(old_count_city, "<", new_count_city)
        assert_compare(old_count_weather, "<", new_count_weather)
        assert_compare(old_count_forecast, "<", new_count_forecast)
    end
    
    # Test update city data in DB
    # Failure unless do not find data updated
    def test_update_city
        response = {:city=>"Palo Alto", :weather_station_city=>"Newark"}
        update_city response
        assert_not_nil(City.first(city: "Palo Alto", 
                                  weather_station_city: "Newark"))
    end
    
    # Test update weather forecast data in DB
    # Failure unless do not find data updated
    def test_update_weather_forecast
        response = {
            :forecast_result=>{
                :forecast=>[
                    {
                        :date=>Date.parse("2014-11-08"), 
                        :temperatures=>{:morning_low=>nil}
                    }, 
                    {
                        :date=>Date.parse("2014-11-09"), 
                        :temperatures=>{:morning_low=>"41"}
                    }
                ]
            }}
        update_weather_forecast response
        assert_not_nil(WeatherForecast.first(date: Date.parse("2014-11-08"), 
                                             temp_morning_low: nil))
        assert_not_nil(WeatherForecast.first(date: Date.parse("2014-11-09"), 
                                             temp_morning_low: 41))
    end

    # Test update weather forecast and city data in DB
    # Failure unless do not find data updated
    def test_update_weather_data
        response = {
            :city=>"Palo Alto", 
            :weather_station_city=>"Newark",
            :forecast_result=>{
                :forecast=>[
                    {
                        :date=>Date.parse("2014-11-08"), 
                        :temperatures=>{:morning_low=>nil}
                    }, 
                    {
                        :date=>Date.parse("2014-11-09"), 
                        :temperatures=>{:morning_low=>"41"}
                    }
                ]
            }}
        update_weather_data (response)
        
        assert_not_nil(City.first(city: "Palo Alto", 
                                  weather_station_city: "Newark"))
        assert_not_nil(WeatherForecast.first(date: Date.parse("2014-11-08"), 
                                             temp_morning_low: nil))
        assert_not_nil(WeatherForecast.first(date: Date.parse("2014-11-09"), 
                                             temp_morning_low: 41))
    end
end