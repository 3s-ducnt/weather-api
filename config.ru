require 'sinatra/base'
require './app/controllers/weather_api'

map('/') { run WeatherApi }