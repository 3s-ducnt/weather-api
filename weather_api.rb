# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require 'sinatra/base'
require 'json'
require './models/dm_config'
require './helpers/init'
require 'nokogiri'
require 'dm-serializer'

class WeatherApi < Sinatra::Base
    configure :production, :development do
        enable :logging
    end
    
    helpers Sinatra::DbHelpers
    helpers Sinatra::ResHelpers
    helpers Sinatra::SoapHelpers
    helpers Sinatra::XmlHelpers
     
    get "/GetWeatherForecastByZip/:zip" do
        begin
            logger.info("#{Time.now} START processing GetWeatherForecastByZip")
            return_message = get_weather_forecast(params[:zip])

            return return_message.to_json if !return_message.empty?

            # call REST API to get weather forecast by zip code
            doc = Nokogiri.XML(get_city_forecast_by_zip_res(params[:zip]))

            # Check response result
            check, return_message = check_response_data(doc)

            # City not found
            return return_message.to_json if !check
            
            # Register weather forecast into DB
            create_weather_data(doc, params[:zip])
            
            # call SOAP API to get weather forecast by Zip code
            response = get_city_forecast_by_zip_soap(params[:zip])

            # Check response result
            check, return_message = check_response_data(nil,response)

            # City not found
            return return_message.to_json if !check

            # Update weather data into DB
            update_weather_data(response)
            
            # Get data from DB and return
            return_message = get_weather_forecast(params[:zip])
        
        rescue SocketError => e
            #Network problem
            logger.error("#{Time.now} ERROR: #{e.message}\n#{e.backtrace.join("\n")}")
            return_message[:status] = 'failed'
            return_message[:message] = 'Can not connect to Weather service '\
                                        'due to Network problem.'
        rescue Exception => e
            # Exception occurred!
            logger.error("#{Time.now} ERROR: #{e.message}\n#{e.backtrace.join("\n")}")
            return_message[:status] = 'failed'
            return_message[:message] = 'Error occurred while getting weather forecast data.'
        ensure
            logger.info("#{Time.now} END processing GetWeatherForecastByZip")
            return return_message.to_json
        end
    end
    
    not_found do
        "API not found!"
    end
    
    get "/" do
        "API not found!"
    end

end

WeatherApi.run!