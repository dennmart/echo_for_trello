Airbrake.configure do |config|
  config.api_key = ENV['ECHO_TRELLO_AIRBRAKE_API']
  config.host    = ENV['ECHO_TRELLO_AIRBRAKE_HOST']
  config.port    = 443
  config.secure  = config.port == 443
end
