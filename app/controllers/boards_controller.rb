class BoardsController < ApplicationController
  before_filter :authenticate

  def index
    @trello = TrelloApi.new(current_user.oauth_token)
    @boards = @trello.boards
  end

  def show
    @trello = TrelloApi.new(current_user.oauth_token)
    @board = @trello.board(params[:id], { lists: 'open', cards: 'open' })
    @card = Card.new(trello_board_id: @board["id"])
  end

  def create
    @card = Card.new(card_params)
    @card.user = current_user
    if @card.save
      @card.set_next_run
      flash[:notice] = 'Your card was saved!'
      redirect_to board_path(@card.trello_board_id)
    else
      flash[:error] = 'Your card was not saved.'
      @trello = TrelloApi.new(current_user.oauth_token)
      @board = @trello.board(@card.trello_board_id, { lists: 'open', cards: 'open' })
      render :show
    end
  end

  def new_list
    @trello = TrelloApi.new(current_user.oauth_token)
    list_response = @trello.create_list(params[:id], params[:list_name])
    if list_response.code == 200
      render json: { success: true, list_id: list_response["id"] }
    else
      render json: { success: false, message: "Trello responsed with the following error: #{list_response.code} - #{list_response.message}" }, status: 422
    end
  end

  private

  def card_params
    params.require(:card).permit(:title, :description, :trello_board_id, :trello_list_id, :frequency, :frequency_period)
  end
end
