require "rails_helper"

RSpec.describe ContactMailer, type: :mailer do
  describe "#send_contact_message" do
    let(:email) { ContactMailer.send_contact_message("John Doe", "johndoe@test.com", "This is my message!") }

    before(:all) do
      @default_email_sender = ENV["DEFAULT_EMAIL_SENDER"]
      ENV["DEFAULT_EMAIL_SENDER"] = "default@test.com"
    end

    after(:all) do
      ENV["DEFAULT_EMAIL_SENDER"] = @default_email_sender
    end

    it "sets the :from header using the specified name and email" do
      expect(email.from).to include("johndoe@test.com")
    end

    it "sets the :to header with the default email sender" do
      expect(email.to).to include(ENV["DEFAULT_EMAIL_SENDER"])
    end

    it "includes the name and email of the sender in the subject" do
      expect(email.subject).to include("John Doe")
      expect(email.subject).to include("johndoe@test.com")
    end

    it "includes the name, email and message in the body" do
      expect(email.body.to_s).to include("John Doe")
      expect(email.body.to_s).to include("johndoe@test.com")
      expect(email.body.to_s).to include("This is my message!")
    end
  end
end
