class ApiController < ApplicationController
	require 'json'
	
	def show_reviews
		if params[:radius] == nil ||
		   params[:lat] == nil ||
		   params[:lon] == nil
		   render :text => "No params"
	    else
			@reviews = Review.near([40.71, 100.23], 2000000) #Review.all
			render :json => @reviews
		end
	end

	
	def upload_image_for_reviews
		if params[:image] == nil &&
		   params[:id] == nil
		   
		   render :text => "No image input or name"
		 else
		 	#upload the image in AWS, then save the name on reviews
		 	review = Review.find(params[:id])
		 	review.adImageLink = "AWS_LINK_IMAGE"
		 	review.save
		 end
	end

	def show_ratings
		@review = Review.find(params[:id])
		@ratings = @review.ratings

		@ratings.each do |rating|
			@listofratings ||= []
			@listofratings << [point: rating.point, description: rating.description, rate1: rating.rate_question1, rate2: rating.rate_question2, rate3: rating.rate_question3, user_name: rating.user.user_name]
		end
		
		render :json => @listofratings
	end

	def get_user_by_rating
		@rating = Rating.find(params[:id])
		@user = @rating.user
		render :json => [user_name: @user.user_name, user_email: @user.user_email]
	end


end
