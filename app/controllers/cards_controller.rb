class CardsController < ApplicationController
  before_filter :authenticate

  def index
    @cards = current_user.cards
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
end
