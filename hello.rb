require 'sinatra'
require 'sinatra/reloader'

get '/' do
  @name = "Thuan Nguyen"
  "Hello #{@name}!"
end
