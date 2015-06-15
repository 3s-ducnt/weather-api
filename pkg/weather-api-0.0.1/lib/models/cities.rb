# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
# Connect database

require './models/application_model'

class Cities  
  include DataMapper::Resource
  property :id, Serial
  property :zip_code, String
  property :weather_station_city, String
  property :city, String
  property :state, String
  property :created, Date
  property :updated, Date
  
  belongs_to :weather_forecast
  
  def created= created_date
    super Date.strptime(created_date, '%d/%m/%Y', now)
  end
  
  def updated= updated_date
    super Date.strptime(updated_date, '%d/%m/%Y', now)
  end
end

DataMapper.finalize       # check their integrity / kiem tra toan ven du lieu