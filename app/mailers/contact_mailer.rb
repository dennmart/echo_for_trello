class ContactMailer < ApplicationMailer
  def send_contact_message(name, email, message)
    @name = name
    @email = email
    @message = message

    mail(to: ENV["DEFAULT_EMAIL_SENDER"], from: "#{@name} <#{@email}>", subject: "[Echo for Trello] Message from #{@name} (#{@email})")
  end
end
