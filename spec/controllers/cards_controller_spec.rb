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
end
