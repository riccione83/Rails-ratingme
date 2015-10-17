module UsersHelper

  def get_current_user_id
      @_curr_user_id =  session[:current_user_id]
  end
end
