class SessionsController < ApplicationController
  def create
    user = User.from_omniauth(request.env["omniauth.auth"])

    if user
      session[:user_id] = user.id
      redirect_to boards_path, :notice => "Signed in!"
    else
      redirect_to root_path, :alert => "Echo For Trello will only allow access to previously logged-in accounts."
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, :notice => "Signed out!"
  end
end
