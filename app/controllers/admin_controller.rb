class AdminController < ApplicationController
  before_filter :admin_authenticate

  def index
    @users_count = User.count
    @cards_count = Card.count
  end

  private

  def admin_authenticate
    # TODO: For now just check my own ID, but maybe fix down the road.
    current_user.id == 1
  end
end
