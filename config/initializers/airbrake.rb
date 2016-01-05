Airbrake.configure do |config|
  config.project_key         = ENV['ECHO_TRELLO_AIRBRAKE_API']
  config.project_id          = true
  config.host                = ENV['ECHO_TRELLO_AIRBRAKE_HOST']
  config.ignore_environments = %w(development test)
end
