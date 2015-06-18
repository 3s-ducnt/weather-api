require 'sinatra/base'
require './weather_api'

map('/') { run WeatherApi }