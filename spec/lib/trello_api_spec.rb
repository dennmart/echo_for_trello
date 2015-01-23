require 'rails_helper'

RSpec.describe TrelloApi do
  describe "#boards" do
    it "returns all of the user's boards with their oAuth token where they opened, are members or part of the organization" do
      stub_request(:get, "#{TrelloApi.base_uri}/members/me/boards?filter=members,open,organization&key=#{ENV['TRELLO_KEY']}&token=trello-oauth-key")
      trello = TrelloApi.new("trello-oauth-key")
      trello.boards
    end

    it "merges any options passed to the method call" do
      stub_request(:get, "#{TrelloApi.base_uri}/members/me/boards?fields=name&filter=members,open,organization&key=#{ENV['TRELLO_KEY']}&token=trello-oauth-key")
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
    pending
  end

  describe "#create_card" do
    pending
  end
end
