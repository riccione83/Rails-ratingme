class RatingmeMailer < ApplicationMailer
  default from: "no-relply@ratingme.com"

  def register_email(user)
    @user = user
    mail(to: @user.user_email, subject: 'Welcome to RatingMe')
  end
  
end
