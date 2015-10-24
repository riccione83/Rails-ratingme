class RatingmeMailer < ApplicationMailer
  default from: "noreply@ratingme.com"


# send a signup email to the user, pass in the user object that   contains the user's email address
  
  def register_email(user)
    @user = user
     mail( :to => @user.user_email,
    :subject => 'Thanks for signing up in RatingMe' )
  end
  
end
