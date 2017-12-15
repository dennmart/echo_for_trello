class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.secrets.default_email_sender
  layout 'mailer'
end
