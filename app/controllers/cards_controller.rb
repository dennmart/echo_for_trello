class CardsController < ApplicationController
  before_action :authenticate

  def index
    @cards = current_user.cards.where(disabled: false).page(params[:page])
    @trello = TrelloApi.new(current_user.oauth_token)
    @boards = @trello.boards(lists: 'open')
  end

  def show
    @card = current_user.cards.find(params[:id])
    @trello = TrelloApi.new(current_user.oauth_token)
    @board = @trello.board(@card.trello_board_id, { lists: 'open', cards: 'open' })
  end

  def update
    @card = current_user.cards.find(params[:id])
    if @card.update_attributes(card_params)
      @card.set_next_run
      flash[:notice] = 'Your card was updated!'
      redirect_to cards_path
    else
      flash[:error] = 'Your card was not updated.'
      @trello = TrelloApi.new(current_user.oauth_token)
      @board = @trello.board(@card.trello_board_id, { lists: 'open', cards: 'open' })
      render :show
    end
  end

  def destroy
    @card = current_user.cards.where(id: params[:id]).first
    if @card
      @card.destroy
      flash[:notice] = "The card '#{@card.title}' has been deleted."
    end
    redirect_to cards_path
  end

  def update_status
    @card = current_user.cards.where(id: params[:id]).first
    @card.toggle!(:disabled) if @card
    redirect_to cards_path
  end

  def logs
    @card_logs = current_user.card_logs.includes(:card).page(params[:page])
  end

  private

  def card_params
    params.require(:card).permit(:title, :description, :trello_board_id, :trello_list_id, :frequency, :frequency_period, :position)
  end
end
