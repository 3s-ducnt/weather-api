# load configuration file for using in application
require 'yaml'
require 'erb'

#APP_CONFIG = YAML.load_file("./config/config.yml")
APP_CONFIG = YAML.load(ERB.new(File.read(File.join("./config","config.yml"))).result)

#DB_CONFIG = YAML.load_file("./config/database.yml")
DB_CONFIG = YAML.load(ERB.new(File.read(File.join("./config","database.yml"))).result)
