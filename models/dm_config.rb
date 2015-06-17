# Data-mapper configuration for DB configuration of development
# and production environment

require 'sinatra/base'
require 'dm-core'
require 'dm-migrations'
require './models/city'
require './models/weather_forecast'
require './models/weather'

class DmConfig < Sinatra::Base
    
    #configuration for development environment
    configure :development do
        DataMapper::Logger.new($stdout, :debug)
        DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/weather_development.db")
        DataMapper.finalize
        DataMapper.auto_upgrade!
    end
    
    #configuration for production environment
    configure :production do
        DataMapper.setup(:default, ENV['DATABASE_URL'])
        DataMapper.finalize
        DataMapper.auto_migrate!
    end
end