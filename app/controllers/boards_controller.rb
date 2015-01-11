class BoardsController < ApplicationController
  before_filter :authenticate

  def index
    @trello = TrelloApi.new(current_user.oauth_token)
    @boards = @trello.boards
    byebug
  end
end
