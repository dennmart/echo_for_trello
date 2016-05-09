require 'rails_helper'

RSpec.describe BoardsController, :type => :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:trello) { double }

  before(:each) do
    sign_in(user)
  end

  describe "#index" do
    it "redirects unauthenticated users to the home page" do
      session[:user_id] = nil
      get :index
      expect(response).to redirect_to(root_url)
    end

    it "returns the user's Trello boards from the API" do
      boards = [{ "id" => 1, "name" => "Board #1" }]
      expect(TrelloApi).to receive(:new).with(user.oauth_token).and_return(trello)
      expect(trello).to receive(:boards).and_return(boards)

      get :index
      expect(assigns(:boards)).to eq(boards)
    end
  end

  describe "#show" do
    let(:board) { { "id" => "123", "name" => "Board #123" } }

    it "redirects unauthenticated users to the home page" do
      session[:user_id] = nil
      get :show, params: { id: 1 }
      expect(response).to redirect_to(root_url)
    end

    it "returns the specified Trello board from the API, with the options to display only open lists and cards" do
      expect(TrelloApi).to receive(:new).with(user.oauth_token).and_return(trello)
      expect(trello).to receive(:board).with("123", { lists: 'open', cards: 'open' }).and_return(board)

      get :show, params: { id: 123 }
      expect(assigns(:board)).to eq(board)
    end

    it "sets up a new Card instance with the specified Trello board ID" do
      allow(TrelloApi).to receive(:new).and_return(trello)
      allow(trello).to receive(:board).and_return(board)

      get :show, params: { id: 123 }
      card = assigns(:card)
      expect(card.trello_board_id).to eq(board["id"])
    end
  end

  describe "#new_list" do
    let(:trello_response) { double }

    before(:each) do
      allow(TrelloApi).to receive(:new).and_return(trello)
      allow(trello).to receive(:create_list).and_return(trello_response)
    end

    it "redirects unauthenticated users to the home page" do
      session[:user_id] = nil
      post :new_list, params: { id: 123, list_name: "Brand-New List" }
      expect(response).to redirect_to(root_url)
    end

    context "valid response" do
      let(:trello_response) { double("code" => 200) }

      before(:each) do
        allow(trello_response).to receive(:[]).with("id").and_return("123")
      end

      it "creates a new list with the specified list params" do
        expect(TrelloApi).to receive(:new).with(user.oauth_token).and_return(trello)
        expect(trello).to receive(:create_list).with("123", "Brand-New List").and_return(trello_response)
        post :new_list, params: { id: 123, list_name: "Brand-New List" }
      end

      it "returns a JSON response indicating a successful request" do
        post :new_list, params: { id: 123, list_name: "Brand-New List" }
        expect(response.status).to eq(200)

        json_response = JSON.parse(response.body)
        expect(json_response["success"]).to eq(true)
        expect(json_response["list_id"]).to eq("123")
      end
    end

    context "invalid response" do
      let(:trello_response) { double("code" => 401, "message" => "invalid board name") }

      it "returns a JSON response with an error message indicating a failed request" do
        post :new_list, params: { id: 123, list_name: "Brand-New List" }
        expect(response.status).to eq(422)

        json_response = JSON.parse(response.body)
        expect(json_response["success"]).to eq(false)
        expect(json_response["message"]).to eq("Trello responsed with the following error: 401 - invalid board name")
      end
    end
  end

  describe "#create" do
    it "redirects unauthenticated users to the home page" do
      session[:user_id] = nil
      post :create
      expect(response).to redirect_to(root_url)
    end

    context "valid card" do
      let(:card_params) { { title: "New Card", frequency: 1, trello_board_id: 1, trello_list_id: 123 } }

      it "creates a new card in the database" do
        expect {
          post :create, params: { card: card_params }
        }.to change(Card, :count).by(1)
      end

      it "sets the current user as the card's user" do
        post :create, params: { card: card_params }
        card = Card.last
        expect(card.user).to eq(user)
      end

      it "sets the card's next run" do
        expect_any_instance_of(Card).to receive(:set_next_run)
        post :create, params: { card: card_params }
      end

      it "redirects to the cards list" do
        post :create, params: { card: card_params }
        expect(response).to redirect_to(cards_path)
      end
    end

    context "invalid card" do
      let(:card_params) { { title: "New Card", trello_board_id: 123 } }

      before(:each) do
        allow(TrelloApi).to receive(:new).and_return(trello)
        allow(trello).to receive(:board)
      end

      it "does not create a new card in the database" do
        expect {
          post :create, params: { card: card_params }
        }.to_not change(Card, :count)
      end

      it "fetches the Trello board from the API again" do
        expect(TrelloApi).to receive(:new).with(user.oauth_token).and_return(trello)
        expect(trello).to receive(:board).with("123", { lists: 'open', cards: 'open' })
        post :create, params: { card: card_params }
      end

      it "renders the 'show' action" do
        post :create, params: { card: card_params }
        expect(response).to render_template(:show)
      end
    end
  end
end
