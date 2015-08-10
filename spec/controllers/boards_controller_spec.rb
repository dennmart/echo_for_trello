require 'rails_helper'

RSpec.describe BoardsController, :type => :controller do
  describe "#index" do
    it "redirects unauthenticated users to the home page" do
      get :index
      expect(response).to redirect_to(root_url)
    end

    it "returns the user's Trello boards from the API"
  end

  describe "#show" do
    it "returns the specified Trello board from the API, with the options to display only open lists and cards"

    it "sets up a new Card instance with the specified Trello board ID"
  end

  describe "#new_list" do
    it "creates a new list with the specified list params"

    it "returns a JSON response indicating a successful request"

    it "returns a JSON response with an error message indicating a failed request"
  end

  describe "#create" do
    context "valid card" do
      it "creates a new card in the database"

      it "sets the card's next run"

      it "redirects to the cards list"
    end

    context "invalid card" do
      it "does not create a new card in the database"

      it "fetches the Trello board from the API again"

      it "renders the 'show' action"
    end
  end
end
