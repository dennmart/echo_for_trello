Airbrake.configure do |config|
  config.project_key         = ENV['ECHO_TRELLO_AIRBRAKE_API'] || "airbrake-api-key"
  config.project_id          = true
  config.host                = ENV['ECHO_TRELLO_AIRBRAKE_HOST'] || "https://test.airbrake.io/"
  config.ignore_environments = %w(development test)
end
