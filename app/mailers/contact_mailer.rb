class ContactMailer < ApplicationMailer
  def send_contact_message(name, email, message)
    @name = name
    @email = email
    @message = message

    mail(to: Rails.application.secrets.default_email_sender, from: "#{@name} <#{@email}>", subject: "[Echo for Trello] Message from #{@name} (#{@email})")
  end
end
