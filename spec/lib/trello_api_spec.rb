require 'rails_helper'

RSpec.describe TrelloApi do
  describe "#boards" do
    it "returns all of the user's open boards with their oAuth token" do
      stub_request(:get, "#{TrelloApi.base_uri}/members/me/boards?filter=open&key=#{ENV['TRELLO_KEY']}&token=trello-oauth-key")
      trello = TrelloApi.new("trello-oauth-key")
      trello.boards
    end

    it "merges any options passed to the method call" do
      stub_request(:get, "#{TrelloApi.base_uri}/members/me/boards?fields=name&filter=open&key=#{ENV['TRELLO_KEY']}&token=trello-oauth-key")
      trello = TrelloApi.new("trello-oauth-key")
      trello.boards(fields: "name")
    end
  end

  describe "#board" do
    it "returns the specified board from the ID with their oAuth token" do
      stub_request(:get, "#{TrelloApi.base_uri}/boards/trello-board-id?key=#{ENV['TRELLO_KEY']}&token=trello-oauth-key")
      trello = TrelloApi.new("trello-oauth-key")
      trello.board("trello-board-id")
    end

    it "merges any options passed to the method call" do
      stub_request(:get, "#{TrelloApi.base_uri}/boards/trello-board-id?fields=name&key=#{ENV['TRELLO_KEY']}&token=trello-oauth-key")
      trello = TrelloApi.new("trello-oauth-key")
      trello.board("trello-board-id", fields: "name")
    end
  end

  describe "#create_list" do
    it "sends a POST request to create a list with their oAuth token, based on the board ID and specified list name" do
      stub_request(:post, "#{TrelloApi.base_uri}/boards/trello-board-id/lists?key=#{ENV['TRELLO_KEY']}&token=trello-oauth-key")
        .with(body: { name: "New List" })
      trello = TrelloApi.new("trello-oauth-key")
      trello.create_list("trello-board-id", "New List")
    end
  end

  describe "#create_card" do
    it "sends a POST request to create a card with their oAuth token, based on the list ID and specified card info" do
      card_info = { title: "Card Title", description: "Card Description" }

      stub_request(:post, "#{TrelloApi.base_uri}/lists/trello-list-id/cards?key=#{ENV['TRELLO_KEY']}&token=trello-oauth-key")
        .with(body: card_info )
      trello = TrelloApi.new("trello-oauth-key")
      trello.create_card("trello-list-id", card_info)
    end
  end
end
