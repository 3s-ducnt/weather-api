# load configuration file for using in application
# Use ERB for uploading to Heroku

require 'yaml'
require 'erb'

APP_CONFIG = YAML.load(ERB.new(File.read(File.join("./config","config.yml"))).result)

DB_CONFIG = YAML.load(ERB.new(File.read(File.join("./config","database.yml"))).result)
