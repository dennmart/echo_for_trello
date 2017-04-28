require 'rails_helper'

RSpec.describe User, :type => :model do
  let(:omniauth) { OmniAuth::AuthHash.new(provider: 'trello', uid: 'new-user-uid', info: { name: 'John Doe', nickname: 'johndoe', email: "johndoe@test.com" }, credentials: { token: 'new-token' }) }

  describe ".from_omniauth" do
    context "with existing user" do
      let!(:user) { FactoryGirl.create(:user) }
      let(:user_omniauth) { OmniAuth::AuthHash.new(provider: user.provider, uid: user.uid, info: { name: user.full_name, nickname: user.nickname, email: "user@test.com" }, credentials: { token: user.oauth_token }) }

      it "returns the user object when matching the provider and UID" do
        expect(User.from_omniauth(user_omniauth)).to eq(user)
      end

      it "does not create a new user record" do
        expect { User.from_omniauth(user_omniauth) }.to_not change(User, :count)
      end

      it "updates the oAuth token if it changed" do
        user_omniauth = OmniAuth::AuthHash.new(provider: user.provider, uid: user.uid, info: { name: user.full_name, nickname: user.nickname, email: user.email }, credentials: { token: 'trello-new-token' })
        expect {
          User.from_omniauth(user_omniauth)
          user.reload
        }.to change(user, :oauth_token)
      end

      it "updates the email if it's not present" do
        expect {
          User.from_omniauth(user_omniauth)
          user.reload
        }.to change(user, :email).from(nil).to("user@test.com")
      end

      it "updates the email if it changed" do
        user.update(email: "user@test.com")
        user_omniauth = OmniAuth::AuthHash.new(provider: user.provider, uid: user.uid, info: { name: user.full_name, nickname: user.nickname, email: "newemail@test.com" }, credentials: { token: user.oauth_token })

        expect {
          User.from_omniauth(user_omniauth)
          user.reload
        }.to change(user, :email).from("user@test.com").to("newemail@test.com")
      end
    end

    context "new user" do
      it "creates a new user if there's not one that matches the provider and UID" do
        expect { User.from_omniauth(omniauth) }.to change(User, :count).by(1)
      end
    end
  end

  describe ".create_from_omniauth" do
    it "creates a new user using the OmniAuth auth hash information" do
      user = User.create_from_omniauth(omniauth)
      expect(user.provider).to eq('trello')
      expect(user.uid).to eq('new-user-uid')
      expect(user.full_name).to eq('John Doe')
      expect(user.nickname).to eq('johndoe')
      expect(user.oauth_token).to eq('new-token')
      expect(user.email).to eq('johndoe@test.com')
    end
  end

  describe "#next_run_info" do
    let(:user) { FactoryGirl.build(:user) }

    before(:each) do
      Timecop.freeze(Time.new(2016, 8, 29, 12, 0, 0)) # Wednesday
    end 

    after(:each) do
      Timecop.return
    end

    it "returns a string with the time for midnight UTC in the user's time zone" do
      user.time_zone = "Pacific Time (US & Canada)"
      expect(user.next_run_info).to eq("5:00 PM (Pacific Time (US & Canada))")

      user.time_zone = "Eastern Time (US & Canada)"
      expect(user.next_run_info).to eq("8:00 PM (Eastern Time (US & Canada))")

      user.time_zone = "Osaka"
      expect(user.next_run_info).to eq("9:00 AM (Osaka)")
    end

    it "defaults to UTC if the user doesn't have a time zone set" do
      user.time_zone = nil
      expect(user.next_run_info).to eq("12:00 AM (UTC)")
    end
  end
end
