# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require 'dm-core'
require 'dm-migrations'

class ApplicationModel
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/api_weather.db")
end