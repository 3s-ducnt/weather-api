# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
require './controllers/application_controller'
require './models/application_model'
#require './models/cities'
#require './models/weathers'
#require './models/weather_forecast'

class HomeController < ApplicationController
  def self.hello
    "Welcome to HomeController"
  end
  
  def self.check_exist_in_db(zip_code)
    city = repository(:default).adapter.select('SELECT count(id) FROM cities WHERE zip_code = "'+zip_code+'"')
    return city.first
  end
  
  def self.insert_to_db(data)
    data.each do |value|
      if value['result'] == true
        value['forecast_result'].each do |row|
          forecast_data = {
            :temp_morning_low         => row['temp_morning_low'],
            :temp_day_time_high       => row['temp_day_time_high'],
            :precipiation_night_time  => row['precipiation_night_time'],
            :precipiation_day_time    => row['precipiation_day_time'],
            :date_time                => row['date_time'],
            :created                  => nil,
            :updated                  => nil,
            :cities                   => [
              :zip_code             => row['zip_code'],
              :weather_station_city => row['weather_station_city'],
              :city                 => row['city'],
              :state                => row['state'],
              :created              => nil,
              :updated              => nil,
            ],
            :weathers                 => [
              :id           => row['weatherID'],
              :description  => row['description'],
              :image_url    => nil
            ]
          }
          WeatherForecast.create(forecast_data)
        end
      end
    end
  end
  
  def self.get_city_forecast_by_zip_from_server(zip_code)
    array = Array.new

    res = RestClient::Request.execute(method: :get, url: "http://wsf.cdyne.com/WeatherWS/Weather.asmx/GetCityForecastByZIP", timeout: 10, headers: {params: {ZIP: "#{zip_code}"}})
    xml_data = res.body

    data = XmlSimple.xml_in(xml_data)
    
#    @doc = Nokogiri::XML.parse(open("http://wsf.cdyne.com/WeatherWS/Weather.asmx/GetCityForecastByZIP?ZIP=#{zip_code}"))
#    xml_data = @doc.to_json

    if data['Success'].first == 'true'
      data['ForecastResult'].each do |forecast|
        results = forecast['Forecast']
        results.each do |r|
          forecast_result = Array.new
          forecast_result.push(
            'zip_code'            => zip_code,
            'state'               => data['State'],
            'city'                => data['City'],
            'weather_station_city'=> data['WeatherStationCity'],
            'date_time'           => r['Date'],
            'weatherID'           => r['WeatherID'],
            'description'         => r['Desciption'],
          )
          r['Temperatures'].each do |temp|
            forecast_result.push(
              'temp_morning_low'    => temp['MorningLow'],
              'temp_day_time_high'  => temp['DaytimeHigh']
            )
          end
          r['ProbabilityOfPrecipiation'].each do |pop|
            forecast_result.push(
              'precipiation_night_time' => pop['Nighttime'],
              'precipiation_day_time'   => pop['Daytime']
            )
          end
          array.push(
            'forecast_result' => forecast_result
          )
        end
      end
    end
    
    array.push(
      'result'  => data['Success'],
      'message' => data['ResponseText']
    )

    return array
  end  
end