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
	skip_before_filter  :verify_authenticity_token
	
	#:user_id, :latitude, :longitude, :title, :description, :question1, :question2, :question3, :isAdvertisement, :adImageLink, :file, :picture
	
	def new_review
		if params[:user_id] != nil or
		   params[:title] != nil or
		   params[:description] != nil or
		   params[:latitude] != nil or
		   params[:longitude] != nil or
		   params[:question1] != nil
		   
		  
		  if User.exists?(:id => params[:user_id])
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
	  	  else
	  	  	render :json => '{"message":"user not exist"}'
	  	  end
  		else
  		  render :json => '{"message":"error in params"}'
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
		if params[:user_id] != nil
			 if User.exists?(:user_name => params[:user_id])
			 	user = User.find_by(:user_name => params[:user_id])
			 	render :json => "{\"message\":\"#{user.id}\"}"
			 else
			   user = User.new
		   	   user.user_name = params[:user_id]
		       user.user_password_hash = "password_di_fantasia"
		       user.user_password_hash_confirmation = "password_di_fantasia"
		       user.user_email = "noemail@ratingme.com"
		       user.user_city = "World"
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

	def login_user
		if params[:user_id] != nil or
		   params[:user_password] != nil
		
		    authorized_user = User.authenticate(params[:user_id],params[:user_password])
		    if authorized_user
		      session[:current_user_id] = authorized_user.id
		      session[:current_user_name] = authorized_user.user_name
		      render :json => "{\"user\":\"#{authorized_user.id}\"}"
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
			@reviews = Review.near([ params[:lat],  params[:lon]], params[:radius], :units => :km)
			
			@reviews.each do |review|
			@user = User.find(review.user_id)
			@listofratings ||= []
			@listofratings << [id: review.id, title: review.title, description: review.description,latitude: review.latitude, longitude: review.longitude, question1: review.question1, question2: review.question2, question3: review.question3,user: @user.user_name,avg_point1: get_point_question1(review),avg_point2: get_point_question2(review),avg_point3: get_point_question1(review),is_advertisement: review.isAdvertisement, ad_image_link: review.adImageLink, point: get_avg_for_review(review),picture: review.picture.url]
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
	    		if Review.exists?(:id => params[:review_id])
	        		@review = Review.find(params[:review_id])
	        		if !@review.ratings.exists?(:user_id => params[:user_id])
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
