class ApiController < ApplicationController

	def show_reviews
		@reviews = Review.all
		render :json => @reviews
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
