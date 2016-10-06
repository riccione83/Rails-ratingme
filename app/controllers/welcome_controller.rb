class WelcomeController < ApplicationController
  layout "welcome"
  
  def home
    if(!request.ssl?)
        puts "WARNING - No SSL connection, redirect to herokuapp"
        redirect_to("https://ratingme.herokuapp.com")
    end
  end
  
  def start
  end
  
  def eula
     render :layout => 'eula'
  end
end
