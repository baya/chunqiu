# rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'
# rails_env = ENV['RAILS_ENV'] || 'development'

# resque_config = YAML.load_file(rails_root + '/config/resque.yml')
# Resque.redis = resque_config[rails_env]

# schedule_config = YAML.load_file(rails_root + '/config/schedule.yml')
# Resque.schedule = schedule_config
require 'resque' # include resque so we can configure it
Resque.redis = "localhost:6379" # tell Resque where redis lives
require 'resque_scheduler'
require 'resque_scheduler/server'
