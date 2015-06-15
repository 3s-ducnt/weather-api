# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require './models/application_model'

class WeatherForecast  
  include DataMapper::Resource
  property :id, Serial
  property :temp_morning_low, Integer
  property :temp_day_time_high, Integer
  property :precipiation_night_time, Integer
  property :precipiation_day_time, Integer
  property :date_time, Date
  property :created, Date
  property :updated, Date
  
  has n, :cities
  has n, :weathers
  
  def created= created_date
    super Date.strptime(created_date, '%d/%m/%Y', now)
  end
  
  def updated= updated_date
    super Date.strptime(updated_date, '%d/%m/%Y', now)
  end
end

DataMapper.finalize       # check their integrity / kiem tra toan ven du lieu
