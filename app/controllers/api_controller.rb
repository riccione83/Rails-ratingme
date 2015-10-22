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



class ApiController < ApplicationController
	require 'json'
	include ReviewsHelper
	skip_before_filter  :verify_authenticity_token
	
	#:user_id, :latitude, :longitude, :title, :description, :question1, :question2, :question3, :isAdvertisement, :adImageLink, :file, :picture
	
	def new_review
		if params[:title] != nil and
		   params[:description] != nil and
		   params[:latitude] != nil and
		   params[:longitude] != nil and
		   params[:question1] != nil
		   
		  @review = Review.new 						#Review.find(params[:id])
		  @review.latitude = params[:latitude]
		  @review.longitude = params[:longitude]
		  @review.title = params[:title]
		  @review.description = params[:description]
		  @review.question1 = params[:question1]
		  @review.question2 = params[:question2]
		  @review.question3 = params[:question3]
		  @review.isAdvertisement = "0"
		  @review.adImageLink = ""
  		  @uploader = PictureUploader.new(@review, params[:picture])
  		  @review.picture = params[:picture]

  		  @uploader.store!(params[:picture])
  		  @review.picture = "#{@uploader.url}"
  		  @review.save
  		  render :json => ["message:success"]
  		else
  		  render :json => ["message:error in params"]
  		end
 	end
	
	def register_new_user
		#:user_name, :user_password_hash, :user_email, :user_city
		if params[:user_name] != nil and
		   params[:user_password_hash] != nil and
		   params[:user_email] != nil and

		   user = User.new
		   user.user_name = params[:user_name]
		   user.user_password_hash = params[:user_password_hash]
		   user.user_password_hash_confirmation = params[:user_password_hash]
		   user.user_email = params[:user_email]
		   user.user_city = params[:user_city]
		   if user.save
		   	render :json => ["message:success"]
		   else
		   	render :json => ["message: #{user.errors}"]
		   end
		else
		   render :json => ["message:error in params"]
		end
	end

	def login_user
		if params[:user_id] != nil and
		   params[:user_password] != nil
		
		    authorized_user = User.authenticate(params[:user_id],params[:user_password])
		    if authorized_user
		      session[:current_user_id] = authorized_user.id
		      session[:current_user_name] = authorized_user.user_name
		      render :json => ["user:#{authorized_user.id}"]
		    else
		     render :json => '{"message":"Invalid Username or Password"}'
		   end
		else
			render :json => ["message:Error on login"]
		end
	end
	
	
	def show_reviews
		if params[:radius] == nil ||
		   params[:lat] == nil ||
		   params[:lon] == nil
		   render :json => ["error:No params"]
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

	def upload_image_for_reviews
		if params[:image] == nil &&
		   params[:id] == nil
		   render :text => "No image input or name"
		else
		 	#upload the image in AWS, then save the name on reviews
		 	review = Review.find(params[:id])
		 	review.picture = "AWS_LINK_IMAGE"
		 	review.save
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
			render :json => ["error:no params"]
		end
	end

	def get_user_by_rating
		@rating = Rating.find(params[:id])
		@user = @rating.user
		render :json => [user_name: @user.user_name, user_email: @user.user_email]
	end


end
