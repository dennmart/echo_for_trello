class BoardsController < ApplicationController
  before_filter :authenticate

  def index
    @trello = TrelloApi.new(current_user.oauth_token)
    @boards = @trello.boards
  end

  def show
    @trello = TrelloApi.new(current_user.oauth_token)
    @board = @trello.board(params[:id], { lists: 'open', cards: 'open' })
  end
end
