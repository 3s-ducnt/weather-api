# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require 'sinatra/base'
require 'sinatra/reloader'
require 'json'
require './models/dm_config'
require './helpers/init'
require 'nokogiri'

class Main < Sinatra::Base
    helpers Sinatra::DbHelpers
    helpers Sinatra::ResHelpers
    helpers Sinatra::SoapHelpers
    helpers Sinatra::XmlHelpers
     
    get "/" do
        "hi!"
    end
    
    get "/GetWeatherForecastByZip/:zip" do
        return_message = {}
        city = find_weather_by_zip(params[:zip])
        if city
            # weather forecast data is existed in DB then return data to client
            return_message[:status] = 'success'
            return_message[:data] = city
        else
            # call REST API to get weather forecast by zip code
            doc = Nokogiri.XML(get_city_forecast_by_zip_res(params[:zip]))
            
            # TODO common method
            if doc.css("Success") == "false"
                return_message[:status] = 'failed'
                return_message[:message] = 'City could not be found in our weather data. Please contact CDYNE for more Details.'
                return return_message.to_json
            end
            
            # insert city data to cities table
            new_city = City.create(build_city(doc))
                        
            forcasts = doc.css("Forecast")
            forcasts.each do |forecast|
                # insert weather forecast data
                WeatherForecast.create(build_weather_forecast(forecast, new_city.id))
            end
            
            # call SOAP API to get weather forecast by Zip code
            doc = Nokogiri.XML(get_city_forecast_by_zip_soap(params[:zip]))
            
            # TODO common method
            if doc.css("Success") == "false"
                return_message[:status] = 'failed'
                return_message[:message] = 'City could not be found in our weather data. Please contact CDYNE for more Details.'
                return return_message.to_json
            end
            
            # update data to DB if result is success, return JSON response
            city = City.first(city: doc.css("City"))
            city.update(build_city(doc))
            
            forcasts = doc.css("Forecast")
            forcasts.each do |forecast|
                # insert weather forecast data
                weather_forecast = WeatherForecast.first(date: forecast.css("Date"))
                weather_forecast.update(build_weather_forecast(forecast, city.id))
            end
            
            # return failed if result failed
            
            # return success
            return_message[:status] = 'success'
            return_message[:data] = backend_response # method build JSON data to response
        end
        return_message.to_json 
    end
    
    not_found do
        "API not found!"
    end
    
end

Main.run!

