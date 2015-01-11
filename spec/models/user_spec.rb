require 'rails_helper'

RSpec.describe User, :type => :model do
  describe ".from_omniauth" do
    context "with existing user" do
      let!(:user) { FactoryGirl.create(:user) }
      let(:omniauth) { OmniAuth::AuthHash.new(provider: user.provider, uid: user.uid, info: { name: user.full_name, nickname: user.nickname }) }

      it "returns the user object when matching the provider and UID" do
        expect(User.from_omniauth(omniauth)).to eq(user)
      end

      it "does not create a new user record" do
        expect { User.from_omniauth(omniauth) }.to_not change(User, :count)
      end
    end

    context "new user" do
      let(:omniauth) { OmniAuth::AuthHash.new(provider: 'trello', uid: 'new-user-uid', info: { name: 'John Doe', nickname: 'johndoe' }) }

      it "creates a new user if there's not one that matches the provider and UID" do
        expect { User.from_omniauth(omniauth) }.to change(User, :count).by(1)
      end
    end
  end

  describe ".create_from_omniauth" do
    let(:omniauth) { OmniAuth::AuthHash.new(provider: 'trello', uid: 'new-user-uid', info: { name: 'John Doe', nickname: 'johndoe' }) }

    it "creates a new user using the OmniAuth auth hash information" do
      user = User.create_from_omniauth(omniauth)
      expect(user.provider).to eq('trello')
      expect(user.uid).to eq('new-user-uid')
      expect(user.full_name).to eq('John Doe')
      expect(user.nickname).to eq('johndoe')
    end
  end
end
