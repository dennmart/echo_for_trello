Airbrake.configure do |config|
  config.project_key         = ENV['ECHO_TRELLO_AIRBRAKE_API'] || "airbrake-api-key"
  config.project_id          = ENV['ECHO_TRELLO_AIRBRAKE_PROJECT_ID'] || "airbrake-project-id"
  config.host                = ENV['ECHO_TRELLO_AIRBRAKE_HOST'] || "https://test.airbrake.io/"
  config.environment         = Rails.env
  config.ignore_environments = %w(development test)
end
