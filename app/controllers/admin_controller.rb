class AdminController < ApplicationController
  before_filter :admin_authenticate

  def index
  end

  private

  def admin_authenticate
    current_user.admin?
  end
end
