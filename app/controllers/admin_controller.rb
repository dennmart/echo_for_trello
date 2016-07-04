class AdminController < ApplicationController
  before_action :admin_authenticate

  def index
  end

  private

  def admin_authenticate
    unless current_user && current_user.admin?
      raise ActionController::RoutingError.new('Not Found')
    end
  end
end
