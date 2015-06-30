# Data-mapper configuration for DB configuration of development
# and production environment

require 'sinatra/base'
require 'dm-core'
require 'dm-migrations'
require './app/models/city'
require './app/models/weather_forecast'
require './app/models/weather'

class DmConfig < Sinatra::Base
    #configuration for development environment  
    configure :development do
        DataMapper::Logger.new($stdout, :debug)
        DataMapper.setup(:default, "#{DB_CONFIG["development"]["db_type"]}#{Dir.pwd}/#{DB_CONFIG["development"]["db_name"]}")
        DataMapper.finalize
        DataMapper.auto_upgrade!
    end

    #configuration for production environment
    configure :production do
        DataMapper.setup(:default, "#{ENV[DB_CONFIG["production"]["database_url"]]}")
        DataMapper.finalize
        DataMapper.auto_migrate!
    end
end