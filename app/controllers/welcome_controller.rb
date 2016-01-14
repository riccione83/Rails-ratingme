class WelcomeController < ApplicationController
  layout "welcome"
  
  def home
  end
  
  def start
  end
  
  def eula
     render :layout => 'eula'
  end
end
