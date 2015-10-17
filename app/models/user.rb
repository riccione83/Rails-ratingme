class User < ActiveRecord::Base
	has_many :ratings
	EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i

	def self.authenticate(username_or_email="", login_password="")

 		 if  EMAIL_REGEX.match(username_or_email)    
 		 	user = User.find_by user_email: username_or_email, user_password_hash: login_password
  		 else
   			user = User.find_by user_name: username_or_email, user_password_hash: login_password
 		 end

  		 if user
    		return user
  		 else
   		    return false
  		 end
	end   

	def match_password(login_password="")
  		encrypted_password == BCrypt::Engine.hash_secret(login_password, salt)
	end


end
