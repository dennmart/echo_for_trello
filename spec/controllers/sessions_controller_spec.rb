require 'rails_helper'

RSpec.describe SessionsController, :type => :controller do
  let(:user) { FactoryGirl.create(:user) }

  describe "#create" do
    context "existing user" do
      before(:each) do
        expect(User).to receive(:from_omniauth).and_return(user)
      end

      it "sets the user ID in the session" do
        get :create, params: { provider: "trello", oauth_token: "token", oauth_verifier: "verifier" }
        expect(session[:user_id]).to eq(user.id)
      end

      it "redirects to the cards page" do
        get :create, params: { provider: "trello", oauth_token: "token", oauth_verifier: "verifier" }
        expect(response).to redirect_to(cards_url)
      end
    end

    context "new user" do
      before(:each) do
        expect(User).to receive(:from_omniauth).and_return(nil)
      end

      it "redirects to the home page with an alert" do
        get :create, params: { provider: "trello", oauth_token: "token", oauth_verifier: "verifier" }
        expect(flash[:alert]).to_not be_empty
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "#destroy" do
    before(:each) do
      session[:user_id] = user.id
    end

    it "clears the user ID in the session" do
      get :destroy
      expect(session[:user_id]).to be_nil
    end

    it "redirects to root" do
      get :destroy
      expect(response).to redirect_to(root_url)
    end
  end
end
