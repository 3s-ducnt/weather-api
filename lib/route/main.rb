# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require 'sinatra'
require 'sinatra/reloader'
require './controllers/home_controller'

get "/" do
  "Welcome to my weatherAPI website"
end

get "/GetCityForecastByZIP" do
  zip_code = params[:ZIP]
  result = HomeController.check_exist_in_db(zip_code)
  print(result)
  if result > 0
    data = "OK"
  else
    data = HomeController.get_city_forecast_by_zip_from_server(zip_code)
    HomeController.insert_to_db(data)
  end
  return data.to_json
end