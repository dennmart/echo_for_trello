class SettingsController < ApplicationController
  before_filter :authenticate

  def index
  end

  def update
    if current_user.update_attributes(user_params)
      flash[:notice] = 'Your settings were saved!'
      redirect_to boards_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:time_zone)
  end
end
