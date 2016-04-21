class ApplicationMailer < ActionMailer::Base
  default from: ENV["DEFAULT_EMAIL_SENDER"]
  layout 'mailer'
end
