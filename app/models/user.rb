class User < ActiveRecord::Base
	EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	
    attr_accessor:user_password_hash_confirmation
	
	validates :user_name, presence: true,:uniqueness => true, length: { minimum: 4 }
	validates :user_password_hash, :presence => true, 
								   :confirmation => true, 
								   length: { minimum: 6 }
	validates :user_password_hash_confirmation, :presence => true
	validates :user_email, :presence => true, :uniqueness => true, :format => EMAIL_REGEX

	has_many :ratings
	
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
