class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :isLoggedIn?, :getCurrentUser, :getInformation

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

  def getInformation(infos)
 	if infos
	    returnedData = Geocoder.search(infos)[0]
   	else
   		returnedData = "No params"
   	end
  end
  
  def forgot_password
     if params[:uname_or_email] and params[:uname_or_email] != ""
       user =  User.user_exist(params[:uname_or_email])
        if user == nil
          flash.now[:error] = "No user or email was found. Please check your input."
        else
          rand_password = ('a'..'z').to_a.shuffle.first(8).join
          user.update_attribute(:user_password_hash, rand_password)
          user.save
          RatingmeMailer.reset_password(user).deliver_now
          flash.now[:success] = "An email was sent to your given address. Please check your inbox mail - " + rand_password
        end
     end
  end

end
