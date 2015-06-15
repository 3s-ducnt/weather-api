# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require "sinatra/base"
require 'sinatra/reloader'
require 'rubygems'
#require 'nokogiri'
require 'open-uri'
require 'rest-client'
require 'xmlsimple'
require 'json'
require './helpers/application_helper'

class ApplicationController < Sinatra::Base
  include ApplicationHelper
end 