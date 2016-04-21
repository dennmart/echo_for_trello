require 'rails_helper'

RSpec.describe SendContactMessageWorker, type: :worker do
  describe "#perform" do
    it "sends an email with the specified parameters" do
      expect(ContactMailer).to receive(:send_contact_message).with("John Doe", "johndoe@test.com", "This is my message!").and_call_original
      SendContactMessageWorker.new.perform({ name: "John Doe", email: "johndoe@test.com", message: "This is my message!" })
      expect(ActionMailer::Base.deliveries).to_not be_empty
    end
  end
end
