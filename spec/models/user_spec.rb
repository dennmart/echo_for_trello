require 'rails_helper'

RSpec.describe User, :type => :model do
  let(:omniauth) { OmniAuth::AuthHash.new(provider: 'trello', uid: 'new-user-uid', info: { name: 'John Doe', nickname: 'johndoe' }, credentials: { token: 'new-token' }) }

  describe ".from_omniauth" do
    context "with existing user" do
      let!(:user) { FactoryGirl.create(:user) }
      let(:user_omniauth) { OmniAuth::AuthHash.new(provider: user.provider, uid: user.uid, info: { name: user.full_name, nickname: user.nickname }, credentials: { token: user.oauth_token }) }

      it "returns the user object when matching the provider and UID" do
        expect(User.from_omniauth(user_omniauth)).to eq(user)
      end

      it "does not create a new user record" do
        expect { User.from_omniauth(user_omniauth) }.to_not change(User, :count)
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
    end
  end
end
