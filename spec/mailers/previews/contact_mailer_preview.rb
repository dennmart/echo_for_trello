# Preview all emails at http://localhost:3000/rails/mailers/contact_maile, headers: { "Content-Type" => "application/json" }r
class ContactMailerPreview < ActionMailer::Preview
  def send_contact_message
    ContactMailer.send_contact_message("John Doe", "johndoe@test.com", "This is a preview of these messages!")
  end
end
