require 'rails_helper'

RSpec.describe AdminController, type: :controller do
  describe "#index" do
    let(:user) { FactoryGirl.create(:user, :admin) }

    it "raises ActionController::RoutingError if there's no current user" do
      expect {
        get :index
      }.to raise_error(ActionController::RoutingError)
    end

    it "returns a 404 if the current user is not an admin" do
      user = FactoryGirl.create(:user)
      sign_in(user)

      expect {
        get :index
      }.to raise_error(ActionController::RoutingError)
    end

    it "renders the index if the current user is an admin" do
      sign_in(user)

      expect {
        get :index
      }.to_not raise_error

      expect(response).to render_template(:index)
    end
  end
end
