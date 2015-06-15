# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
require 'sinatra'
require 'sinatra/reloader'

class HomeController
  get "/" do
    "Hello World"
  end
  get "/WeatherWS/Weather.asmx/GetCityForecastByZIP" do
    zip_code = params[:ZIP]
    "#{zip_code}"
  end
end
