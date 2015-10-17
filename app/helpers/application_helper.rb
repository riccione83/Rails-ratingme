module ApplicationHelper

public

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
