# API version 0.1

# api/show_reviews
#
# Params: 
# lat => Latitude in decimal
# lon => Longitude in decimal
# radius => Radius in decimal
# Returned:
# Json of reviews inside the radius

# api/show_ratings
#
# Params:
# id => The id of a Review
# Returned:
# The Json model of the rating of the review's id

# api/get_user_by_rating
#
# Params:
# id => The id of a rate
#
# Returned:
# Json model of user that have created the rate

# api/new_review
# api/register_new_user
# api/login_user

class ApiController < ApplicationController
	require 'json'
	include ReviewsHelper
	include ApplicationHelper
	include MessagesHelper
	skip_before_filter  :verify_authenticity_token
	
	def get_num_of_messages
		if params[:user_id] != nil
			user = User.find(params[:user_id])
			render :json => user.messages.count.as_json
		else
			render :json => '{"message":"error in params"}'
		end	
	end
	
	def get_messages
		if params[:user_id] != nil
			user = User.find(params[:user_id])
			render :json => user.messages.order(:created_at).as_json
		else
			render :json => '{"message":"error in params"}'
		end	
	end
	
	def delete_all_messages
		if params[:user_id] != nil
		   user = User.find(params[:user_id])
		   user.messages.all.destroy_all
		   user = User.find(params[:user_id])
		   render :json => user.messages.order(:created_at).to_json
		else
			render :json => '{"message":"error in params"}'
		end   
	end
	
	def delete_message
		if params[:user_id] != nil and
		   params[:message_id] != nil
		   user = User.find(params[:user_id])
		   message = Message.find(params[:message_id])
		   if message
		   		message.destroy
		   		render :json => user.messages.order(:created_at).to_json
		   end	
		else
			render :json => '{"message":"error in params"}'
		end   
	end
	
	def set_message_unread
		if params[:user_id] != nil and
		   params[:message_id] != nil
		   user = User.find(params[:user_id])
		   message = Message.find(params[:message_id])
		   if message
		   		message.status = 0
		   		message.save
		   		render :json => user.messages.order(:created_at).to_json
		   end	
		else
			render :json => '{"message":"error in params"}'
		end   
	end
	
	def set_message_read
		if params[:user_id] != nil and
		   params[:message_id] != nil
		   user = User.find(params[:user_id])
		   message = Message.find(params[:message_id])
		   if message
		   		message.status = 1
		   		message.save
		   		render :json => user.messages.order(:created_at).to_json
		   end	
		else
			render :json => '{"message":"error in params"}'
		end   
	end
	
	def new_review
		if params[:user_id] != nil or
		   params[:title] != nil or
		   params[:description] != nil or
		   params[:latitude] != nil or
		   params[:longitude] != nil or
		   params[:question1] != nil
		   
		   city = [params[:latitude],params[:longitude]]
    	   @near_reviews = Review.near(city, 0.010, :units => :km)
		   if @near_reviews.any?
    			 render :json => '{"error":"There is another Review at this point. Please try again in another location. Thankyou."}'
    	   else
			  if User.exists?(:id => params[:user_id])
			  	user = User.find(params[:user_id])
			  	if user.reported == "1"
			  		render :json => '{"error":"Sorry, your account is locked because someone has report you. You cannot create new Review. Please contact us to unlock."}'
			  	else
			  	  @review = Review.new 						#Review.find(params[:id])
			  	  @review.latitude = params[:latitude]
				  @review.longitude = params[:longitude]
				  @review.title = params[:title]
				  @review.description = params[:description]
				  @review.question1 = params[:question1]
				  @review.question2 = params[:question2]
				  @review.question3 = params[:question3]
				  @review.user_id = params[:user_id]
				  @review.isAdvertisement = "0"
				  @review.adImageLink = ""
				  if  params[:picture] != nil
		  		  	@uploader = PictureUploader.new(@review, params[:picture])
		  		  	@review.picture = params[:picture]
	
		  		  	@uploader.store!(params[:picture])
		  		  	@review.picture = "#{@uploader.url}"
		  		  end
	  		  	  @review.save
	  		  	  render :json => '{"message":"success"}'
	  		  	end
	  	  	  else
	  	  		render :json => '{"message":"user not exist"}'
	  	  	  end
	  	 	end
  		 else
  		  render :json => '{"message":"error in params"}'
  		end
 	end
 	
    def report_review
     if params[:review_id] != nil
       @review = Review.find(params[:review_id])
       @review.update_attribute('reported', '1')
       @user = User.find(@review.user_id)
       RatingmeMailer.reported_review(@user,@review).deliver_now
       new_message_for_user(@user,"Someone has reported your Review.","Someone has reported that your Review contain inappropriate material.<br>The Review is titled: " + @review.title + "<br>Please modify it.",true)
       render :json => '{"message":"Thankyou. Your help is greatly appreciated. A moderator will check this Review and will delete it if will be necessary."}'
     else
     	render :json => '{"error":"Error in params"}'
     end
    end
    
    
    def report_user
	  if params[:review_id] != nil
	  	@review = Review.find(params[:review_id])
        @user = User.find(@review.user_id)
    	@user.update_attribute('reported', '1')
    	RatingmeMailer.reported_user(@user).deliver_now
    	new_message_for_user(@user,"Someone has reported your account. Please login and modify your Reviews or Ratings.","Someone has reported that your account has published inappropriate material. Please modify your Reviews or Ratings.",true)
    	render :json => '{"message":"Thankyou. Your help is greatly appreciated. A moderator will check this User and will ban it if will be necessary."}'
	  else
     	render :json => '{"error":"Error in params"}'    	
      end
  	end
	
	def register_new_user
     	if params[:user_name] != nil or
		   params[:user_password_hash] != nil or
		   params[:user_email] != nil

		  	if User.exists?(user_name: params[:user_name])
		  	 	render :json => '{"message":"User name already exist"}'
		  	else
		   		user = User.new
		   		user.user_name = params[:user_name]
		   		user.user_password_hash = params[:user_password_hash]
		   		user.user_password_hash_confirmation = params[:user_password_hash]
		   		user.user_email = params[:user_email]
		   		user.user_city = params[:user_city]
		   		if params[:device_token] != nil
		   			user.device_token = params[:device_token]
		   		end
		   		if user.save
		   			RatingmeMailer.register_email(user).deliver_now
		   			render :json => "{\"user\":\"#{user.id}\"}"
		   		else
		   			render :json => "{\"message\":\"#{user.errors.full_messages[0]}\"}"
		   		end
		  	end
		else
		   render :json => '{"message":"Error in params"}'
		end
	end

	def login_with_social
		if params[:user_name] == nil											# For old iOS App compability
			if params[:user_id] != nil
			 	if User.exists?(:user_name => params[:user_id])
				 	user = User.find_by(:user_name => params[:user_id])
				 	if params[:device_token] != nil
		   				user.update_attribute('device_token', params[:device_token])
		   			end
				 	if user.reported == '1'
		      			render :json => "{\"message\":\"#{user.id}\",\"info\":\"Hi, someone has reported that you have some Review that don't respect our user agreement. Your account is blocked and you cannot create new Review or Rating. Please contact us to unlock your account.\"}"
		      		else
				 		render :json => "{\"message\":\"#{user.id}\"}"
				 	end
				 	
				 	main_user = User.find(1)
    				new_message_for_user(main_user,"New login from social via APP","Wow! new user has logged in: <br><b> " + user.user_name + "</b>", true)
      
			 	else
			   		user = User.new
		   	   		user.user_name = params[:user_id]
		       		user.user_password_hash = "changeme"
		       		user.user_password_hash_confirmation = "changeme"
		       		user.user_email = params[:user_id] + "@ratingme.eu"
		       		user.user_city = ""
		       		if params[:device_token] != nil
			   			user.device_token = params[:device_token]
			   		end
		   			if user.save	
			   			render :json => "{\"message\":\"#{user.id}\"}"
		   			else
			   			render :json => '{"error": "error on register user"}'
					end
			 	end
			else
				render :json => '{"error":"parameter error"}'
			end
		else
			if params[:user_id] != nil											# if we pass user_name params we have a new version of iOS app
				if User.exists?(:uid => params[:user_id])
				 	user = User.find_by(:uid => params[:user_id])
				 	if params[:device_token] != nil
		   				user.update_attribute('device_token', params[:device_token])
		   			end				 	

				 	main_user = User.find(1)
    				new_message_for_user(main_user,"New login from social via APP","Wow! new user has logged in: <br><b> " + user.user_name + "</b>", true)

				 	if user.reported == '1'
		      			render :json => '{\"message\":\"#{user.id}\","info":"Hi, someone has reported that you have some Review that don\'t respect our user agreement. Your account is blocked and you cannot create new Review or Rating. Please contact us to unlock your account."}'
		      		else
			 			render :json => "{\"message\":\"#{user.id}\"}"
			 		end
			 	else
			   		user = User.new
		   	   		user.user_name = params[:user_name]
		   	   		user.provider = params[:provider]
		   	   		user.uid =  params[:user_id]
		       		user.user_password_hash = "changeme"
		       		user.user_password_hash_confirmation = "changeme"
		       		user.user_email =  params[:user_id] + "@ratingme.eu"
		       		user.user_city = ""
		       		if params[:device_token] != nil
			   			user.device_token = params[:device_token]
			   		end		       		
		   			if user.save	
		   				render :json => "{\"message\":\"#{user.id}\"}"
		   			else
			   			render :json => '{"error": "error on register user"}'
					end
			 	end
			else
				render :json => '{"error":"parameter error"}'
			end
		end
	end

	def login_user
		if params[:user_id] != nil or
		   params[:user_password] != nil
		
		    authorized_user = User.authenticate(params[:user_id],params[:user_password])
		    if authorized_user
		      session[:current_user_id] = authorized_user.id
		      session[:current_user_name] = authorized_user.user_name
			  if params[:device_token] != nil
		   		authorized_user.update_attribute('device_token', params[:device_token])
		   	  end		      
	
	     	  main_user = User.find(1)
    		  new_message_for_user(main_user,"New login via APP","Wow! new user has logged in via App: <br><b> " + authorized_user.user_name + "</b>", true)
		   	  
		      if authorized_user.reported == '1'
		      	render :json => "{\"user\":\"#{authorized_user.id}\",\"info\":\"Hi, someone has reported that you have some Review that don't respect our user agreement. Your account is blocked and you cannot create new Review or Rating. Please contact us to unlock your account.\"}"
		      else	
		      	render :json => "{\"user\":\"#{authorized_user.id}\"}"
		      end
		    else
		     render :json => '{"message":"Invalid Username or Password"}'
		    end
		else
			render :json => '{"message":"Error on login"}'
		end
	end
	
	
	def show_reviews
		if params[:radius] == nil or
		   params[:lat] == nil or
		   params[:lon] == nil
		   render :json => '{"error":"No params"}'
	    else
			@reviews = Review.near([ params[:lat],  params[:lon]], params[:radius], :units => :km).where.not(reported: "1")
			
			@reviews.each do |review|
				@user = User.find(review.user_id)
				@listofratings ||= []
				@listofratings << [id: review.id, title: review.title, description: review.description,latitude: review.latitude, longitude: review.longitude, question1: review.question1, question2: review.question2, question3: review.question3,user: @user.user_name,avg_point1: get_point_question1(review),avg_point2: get_point_question2(review),avg_point3: get_point_question3(review),is_advertisement: review.isAdvertisement, ad_image_link: review.adImageLink, point: get_avg_for_review(review),picture: review.picture.url]
			end
			render :json => @listofratings
		end
	end
	
	def search_reviews
		 if params[:search] == nil or params[:search] == ""
		 	render :json => '{"error":"No params"}'
		 else
        	@reviews = Review.search(params[:search]).order("created_at DESC").where.not(reported: "1")
        	@reviews.each do |review|
				@user = User.find(review.user_id)
				@listofratings ||= []
				@listofratings << [id: review.id, title: review.title, description: review.description,latitude: review.latitude, longitude: review.longitude, question1: review.question1, question2: review.question2, question3: review.question3,user: @user.user_name,avg_point1: get_point_question1(review),avg_point2: get_point_question2(review),avg_point3: get_point_question3(review),is_advertisement: review.isAdvertisement, ad_image_link: review.adImageLink, point: get_avg_for_review(review),picture: review.picture.url]
			end
			render :json => @listofratings
         end
	end
	

    #:review_id, :user_name, :point, :description, :rate_question1, :rate_question2, :rate_question3
	def new_rating 
		if params[:review_id] == nil or
		   params[:user_id] == nil or
		   params[:description] == nil or
		   params[:rate_question1] == nil or
		   params[:rate_question2] == nil or
		   params[:rate_question3] == nil
		   	render :json => '{"error":"No params"}'
	    else
	    	if User.exists?(:id => params[:user_id])
	    		@user = User.find(params[:user_id])
	    		if @user.reported == "1"
			  		render :json => '{"error":"Sorry, your account is locked because someone has report you. You cannot Rating. Please contact us to unlock."}'
			  	else
	    			if Review.exists?(:id => params[:review_id])
		        		@review = Review.find(params[:review_id])
	        			if !@review.ratings.exists?(:user_id => params[:user_id])
	        				usr = User.find(@review.user_id)
	        				send_message_to_user(usr,"Wow! Someone has written a new Rating at your Review!") if usr != nil
	       					@rating = @review.ratings.new
       						@rating.description = params[:description]
       						@rating.rate_question1 = params[:rate_question1]
       						@rating.rate_question2 = params[:rate_question2]
       						@rating.rate_question3 = params[:rate_question3]
       						@rating.user = @user
       						@rating.save
       						render :json => '{"message":"success"}'
       					else
	       					render :json => '{"error":"You can rate only one time."}'
       					end
       				else
		       			render :json => '{"error":"No review found"}'
        			end
        		end
        	else
        		render :json => '{"error":"No user found"}'
        	end
       	end
	end
	
	def show_ratings
		if params[:id] != nil
			@review = Review.find(params[:id])
			@ratings = @review.ratings

			@ratings.each do |rating|
				@listofratings ||= []
				@listofratings << [point: rating.point, description: rating.description, rate1: rating.rate_question1, rate2: rating.rate_question2, rate3: rating.rate_question3, user_name: rating.user.user_name]
			end
			render :json => @listofratings
		else
			render :json => '{"error":"no params"}'
		end
	end

	def get_user_by_rating
		@rating = Rating.find(params[:id])
		@user = @rating.user
		render :json => [user_name: @user.user_name, user_email: @user.user_email]
	end

end
