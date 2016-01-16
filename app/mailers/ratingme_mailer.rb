class RatingmeMailer < ApplicationMailer
 default :from => 'RatingMe'

# send a signup email to the user, pass in the user object that   contains the user's email address
  
  def register_email(user)
    @user = user
     mail( :to => @user.user_email,
    :subject => 'Thanks for signing up in RatingMe' )
  end
  
   def reset_password(user)
    @user = user
     mail( :to => @user.user_email,
    :subject => 'Your new RatingMe password' )
   end
  
end
