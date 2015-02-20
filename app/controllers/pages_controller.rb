class PagesController < ApplicationController
  include HighVoltage::StaticPage

  before_filter :redirect_if_authenticated, only: [:home]
  layout 'static'

  private

  def redirect_if_authenticated
    if session[:user_id]
      redirect_to boards_path
    end
  end

  def layout_for_page
    case params[:id]
    when 'home'
      'home'
    else
      'application'
    end
  end
end
