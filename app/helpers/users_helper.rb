module UsersHelper

  def get_user_message_path
    return '../users/' + get_current_user_id.to_s + '/messages'
  end
  
  def get_number_of_unread_message()
    user = User.find(get_current_user_id)
    return user.messages.where(status: 0).count
  end

  def get_current_user_id
      @_curr_user_id =  session[:current_user_id]
  end
end
