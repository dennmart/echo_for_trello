OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :trello, ENV['TRELLO_KEY'], ENV['TRELLO_SECRET'],
    app_name: "Trello Echo", scope: 'read,write', expiration: 'never'
end
