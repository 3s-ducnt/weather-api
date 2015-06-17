# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require 'sinatra/base'
require 'sinatra/reloader'
require 'json'
require './models/dm_config'
require './helpers/init'
require 'nokogiri'
require 'dm-serializer'

class Main < Sinatra::Base
    helpers Sinatra::DbHelpers
    helpers Sinatra::ResHelpers
    helpers Sinatra::SoapHelpers
    helpers Sinatra::XmlHelpers
     
    get "/" do
        "hi!"
    end
    
    get "/GetWeatherForecastByZip/:zip" do
        return_message = get_weather_data(params[:zip])
        
        return return_message.to_json if !return_message.empty?
        
        # call REST API to get weather forecast by zip code
        doc = Nokogiri.XML(get_city_forecast_by_zip_res(params[:zip]))

        # Check response result
        check, return_message = check_response_data(doc)

        # City not found
        return return_message.to_json if !check

        # insert city data to cities table
        new_city = create_city(doc)
        
        puts "City has just created #{new_city.id}"
        
        # insert weather forecast to DB
        create_weather_forecast(doc, new_city.id)

        # call SOAP API to get weather forecast by Zip code
        weather_data = get_city_forecast_by_zip_soap(params[:zip])
        
        # Check response result
        #check, return_message = check_response_data(doc)
        
        # City not found
        #return return_message.to_json if !check

        # update city data to DB
        #updated_city = update_city(doc)
        
        #logger.info("City has just updated #{city.id}")

        # update weather forecast to DB
        #update_weather_forecast(doc, updated_city.id)

        # Get data from DB and return
        return_message = get_weather_data(params[:zip])
        return_message.to_json
    end
    
    not_found do
        "API not found!"
    end
    
end

Main.run!

