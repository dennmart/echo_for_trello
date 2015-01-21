class BoardsController < ApplicationController
  before_filter :authenticate

  def index
    @trello = TrelloApi.new(current_user.oauth_token)
    @boards = @trello.boards
  end

  def show
    @trello = TrelloApi.new(current_user.oauth_token)
    @board = @trello.board(params[:id], { lists: 'open', cards: 'open' })
    @list_options = @board['lists'].collect { |list| [list['name'], list['id']] }
    @list_options << ['Create a new list...', 'new_list']
  end

  def new_list
    # params:
    # id - Trello Board ID
    # list_name: List name
    @trello = TrelloApi.new(current_user.oauth_token)
    list_response = @trello.create_list(params[:id], params[:list_name])
    if list_response.code == 200
      render json: { success: true, list_id: list_response["id"] }
    else
      render json: { success: false, message: "Trello responsed with the following error: #{list_response.code} - #{list_response.message}" }, status: 422
    end
  end
end
