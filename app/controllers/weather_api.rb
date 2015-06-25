# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require 'sinatra/base'
require 'json'
require 'nokogiri'
require 'dm-serializer'
require './config/initializers/load_config'
require './config/dm_config'
require './app/services/weather_service'


class WeatherApi < Sinatra::Base
    configure :production, :development do
        enable :logging
    end
     
    get "/GetWeatherForecastByZip/:zip" do
        begin        
            logger.info("#{Time.now} START processing GetWeatherForecastByZip")
            
            return_message = WeatherService.get_weather_forecast_by_zip(params[:zip])
            return_message.to_json
        
        rescue SocketError => se
            logger.error("#{Time.now} ERROR: #{se.message}\n#{se.backtrace.join("\n")}")
            # Service unavailable: 503
            halt(APP_CONFIG["service_unavailable_cd"], 
                    {status: APP_CONFIG["failed"], message: APP_CONFIG["network_error"]}.to_json)
        rescue => e
            logger.error("#{Time.now} ERROR: #{e.message}\n#{e.backtrace.join("\n")}")
            if e.message == APP_CONFIG["city_not_found"]
                halt(APP_CONFIG["bad_request_cd"],
                    {status: APP_CONFIG["failed"], message: e.message}.to_json)
            end
            # Internal server error: 500
            halt(APP_CONFIG["internal_error_cd"],
                {status: APP_CONFIG["failed"], message: APP_CONFIG["general_error"]}.to_json)
        end
    end
    
    not_found do
        APP_CONFIG["api_not_found"]
    end
    
    get "/" do
        APP_CONFIG["api_not_found"]
    end

end

WeatherApi.run!