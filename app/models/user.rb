class User < ActiveRecord::Base
	EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	
    attr_accessor:user_password_hash_confirmation
	
	validates :user_name, presence: true,:uniqueness => true, length: { minimum: 4 }
	validates :user_password_hash, :presence => true, 
								   :confirmation => true, 
								   length: { minimum: 6 }
	validates :user_password_hash_confirmation, :presence => true
	validates :user_email, :presence => true, :uniqueness => true , :format => EMAIL_REGEX, :on => [ :create ]

	has_many :ratings
	
	def self.from_omniauth(auth)
	 		where(provider: auth.provider, uid: auth.uid).first_or_create.tap do |user|
      			if user.new_record?
      				c_user = User.all.where(:user_name => auth.info.name)
					if c_user.any?
						return "Username already registered. Please login with your credentials."
					else
	      				user.provider = auth.provider
      					if auth.provider == "twitter"
	      					user.user_name = auth.info.nickname + " via Twitter"
      					else
	    					user.user_name = auth.info.name
    					end
    					user.uid = auth.uid
    					if auth.info.email != "" and auth.info.email != nil
	    	  				user.user_email =  auth.info.email
    					else
	    	 				user.user_email = auth.uid + "@ratingme.eu"
    					end
    					user.user_password_hash = "changeme"
    					user.user_password_hash_confirmation = "changeme"
    					user.user_city = auth.info.location
      					user.save!
      				end
      			end
     		end
    end
    
	def self.user_exist(username_or_email="")
	 	if  EMAIL_REGEX.match(username_or_email)    
 		 	user = User.find_by user_email: username_or_email
  		else
   			user = User.find_by user_name: username_or_email
 		end

  		if user
    		return user
  		else
   		    return nil
  		end
	end
	
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
