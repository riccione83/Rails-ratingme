module ApplicationHelper

public
  
def get_lat_for_user_city
     @user = User.find(session[:current_user_id])

end

def get_lon_for_user_city
     @user = User.find(session[:current_user_id])
end


def get_user_city
    if session[:current_user_id] != nil
        @user = User.find(session[:current_user_id])
        return @user.user_city
    else
        return nil
    end
end

def userIsLoggedIn
   
   if session[:current_user_id] == nil
       return false
   end
   return true

end

def getRandomCode
  return (0...8).map { (65 + rand(26)).chr }.join
end

def userLocked
    if session[:user_reported] = 1
       return true
    else
        return false
    end
end

def flash_class(level)
    if level == "notice"
    	return "alert alert-info alert-dismissible"
    elsif level == "success" 
    	return "alert alert-success alert-dismissible"
    elsif level == "error" 
    	return "alert alert-danger alert-dismissible"
    elsif level == "alert"
    	return "alert alert-warning alert-dismissible"
    end
end

end
