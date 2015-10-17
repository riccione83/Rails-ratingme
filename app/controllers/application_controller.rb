class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :isLoggedIn?, :getCurrentUser

  def isLoggedIn?
  	if session[:current_user_id] == nil
  		return false
  	else
  		return true
  	end
  end

  def getCurrentUser
  	return session[:current_user_id]
  end

end
