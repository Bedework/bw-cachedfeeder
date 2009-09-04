# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'test'
# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
require RAILS_ROOT + '/lib/hpricot-0.6.161-java/lib/universal-java1.5/fast_xs'
require RAILS_ROOT + '/lib/hpricot-0.6.161-java/lib/universal-java1.5/hpricot_scan'
#require RAILS_ROOT + '/lib/hpricot-0.6.161-java/lib'
#include Java
#require RAILS_ROOT + '/vendor/gems/hpricot-0.6.164/lib/universal-java1.6/hpricot_scan.jar'

#

Rails::Initializer.run do |config|
  ## RACKING
  
    #config.gem "sinatra"
    config.gem "builder"
    #config.gem "json"
    # config.gem "hpricot"

    config.time_zone = 'UTC'
  
      
  ## END
  # config/initializers/load_config.rb
APP_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/config.yml")
  
config.load_paths += Dir["#{RAILS_ROOT}/vendor/gems/**"].map do |dir| 
  File.directory?(lib = "#{dir}/lib") ? lib : dir
end
config.load_paths << RAILS_ROOT + '/lib/hpricot-0.6.161-java/lib'
  config.gem "httpclient"
  # Settings in config/environments/* take precedence over those specified here
  # Skip frameworks you're not going to use (only works if using vendor/rails)
  config.frameworks -= [ :active_record ]

  # Only load the plugins named here, by default all plugins in vendor/plugins are loaded
  # config.plugins = %W( exception_notification ssl_requirement )

  # Add additional load paths for your own custom dirs
   #config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store
  config.action_controller.session = { :key => "_myapp_session", :secret => "850fe3dfa6dcdd4334916afd9fb36b9c" } 
  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc

  # Add new inflection rules using the following format
  # (all these examples are active by default):
  # Inflector.inflections do |inflect|
  #   inflect.plural /^(ox)$/i, '\1en'
  #   inflect.singular /^(ox)en/i, '\1'
  #   inflect.irregular 'person', 'people'
  #   inflect.uncountable %w( fish sheep )
  # end

  # See Rails::Configuration for more options
end

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register "application/x-mobile", :mobile

# Include your application configuration below
  #set :env, :production
  #disable :run, :reload

  # Remove trailing slash from URIs reaching Sinatra
  #before { request.env['PATH_INFO'].gsub!(/\/$/, '') if request.env['PATH_INFO'] != '/' }

  # Checking AR Connections back to the pool
  #after { ActiveRecord::Base.clear_active_connections! }

  # Preload controllers with Sinatra code
 # require 'parse_controller'