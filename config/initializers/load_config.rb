# load configuration file for using in application
require 'yaml'

APP_CONFIG = YAML.load_file("./config/config.yml")

DB_CONFIG = YAML.load_file("./config/database.yml")
