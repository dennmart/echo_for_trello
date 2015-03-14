require 'rails_helper'

RSpec.describe SettingsController, type: :controller do
  let(:user) { FactoryGirl.create(:user, time_zone: "Eastern Time (US & Canada)") }

  before(:each) do
    sign_in(user)
  end

  describe "#index" do
    it "renders the index view" do
      get :index
      expect(response).to render_template('index')
    end
  end

  describe "#update" do
    context "successful update" do
      it "updates the user's timezone" do
        expect {
          put :update, id: user.id, user: { time_zone: "Pacific Time (US & Canada)" }
          user.reload
        }.to change(user, :time_zone).from("Eastern Time (US & Canada)").to("Pacific Time (US & Canada)")
      end

      it "redirects the user to the boards page" do
        put :update, id: user.id, user: { time_zone: "Pacific Time (US & Canada)" }
        expect(response).to redirect_to(boards_path)
      end
    end
  end
end
