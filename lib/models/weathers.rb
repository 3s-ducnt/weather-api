# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require './models/application_model'

class Weathers  
  include DataMapper::Resource
  property :id, Serial
  property :description, String
  property :image_url, String
  
  belongs_to :weather_forecast
end

DataMapper.finalize       # check their integrity / kiem tra toan ven du lieu