module ControllerMethods
  def sign_in(user)
    session[:user_id] = user.id
  end
end
