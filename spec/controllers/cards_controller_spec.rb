require 'rails_helper'

RSpec.describe CardsController, :type => :controller do
  let(:user) { FactoryGirl.create(:user) }

  before(:each) do
    sign_in(user)
  end

  describe "#index" do
    it "fetches the current user's enabled cards" do
      new_user = FactoryGirl.create(:user)
      user_card = FactoryGirl.create(:card, user: user)
      new_user_card = FactoryGirl.create(:card, user: new_user)
      disabled_card = FactoryGirl.create(:card, user: user, disabled: true)

      boards = double
      expect_any_instance_of(TrelloApi).to receive(:boards).and_return(boards)

      get :index
      expect(assigns(:cards)).to include(user_card)
      expect(assigns(:cards)).to_not include(new_user_card, disabled_card)
      expect(assigns(:boards)).to eq(boards)
    end
  end

  describe "#destroy" do
    it "destroys the specified card for the current user" do
      card = FactoryGirl.create(:card, user: user)

      expect {
        delete :destroy, params: { id: card.id }
      }.to change(Card, :count).by(-1)
    end

    it "doesn't destroy a card if it doesn't belong to the current user" do
      new_user_card = FactoryGirl.create(:card)

      expect {
        delete :destroy, params: { id: new_user_card.id }
      }.to_not change(Card, :count)
    end
  end

  describe "#update_status" do
    it "disables the card if the card is enabled" do
      card = FactoryGirl.create(:card, user: user, disabled: false)

      expect {
        put :update_status, params: { id: card.id }
        card.reload
      }.to change(card, :disabled).from(false).to(true)
    end

    it "enables the card if the card is disabled" do
      card = FactoryGirl.create(:card, user: user, disabled: true)

      expect {
        put :update_status, params: { id: card.id }
        card.reload
      }.to change(card, :disabled).from(true).to(false)
    end

    it "does nothing if the card does not belong to the user" do
      card = FactoryGirl.create(:card)

      expect {
        put :update_status, params: { id: card.id }
        card.reload
      }.to_not change(card, :disabled)
    end
  end

  describe "#logs" do
    it "fetches the current user's card logs" do
      new_user = FactoryGirl.create(:user)
      user_log = FactoryGirl.create(:card_log, user: user)
      new_user_log = FactoryGirl.create(:card_log, user: new_user)

      get :logs
      expect(assigns(:card_logs)).to include(user_log)
      expect(assigns(:card_logs)).to_not include(new_user_log)
    end
  end
end
