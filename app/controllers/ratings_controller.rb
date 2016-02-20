class RatingsController < ApplicationController
  include ApplicationHelper  
  include MessagesHelper
  
  before_action :set_rating, only: [:show, :edit, :update, :destroy]

  # GET /ratings
  # GET /ratings.json
  def index
    @review = Review.find(params[:review_id])
    @ratings = @review.ratings.all.where.not(reported: "1")
    @user = @ratings.first.user
  end

  def show_reported_rating
     @ratings = Rating.all.paginate(page: params[:page], per_page: 10).order("created_at DESC").where.not(reported: "0")
  end
  
  def report_rating
    @rating = Rating.find(params[:id])
    @rating.update_attribute('reported', '1')
    new_message_for_user(@user,"Someone has reported your Rating. Please login and modify it.","Someone has reported that your Rating contain inappropriate material.<br>The Rating is titled: " + @rating.description + "<br>Please modify it <a href='#{rating_path(params[:id])}'>here </a>",true)
    flash[:notice] = "Rating reported. Thankyou."
    redirect_to(rating_path(params[:id]))
  end
  
  def reset_rating
    @rating = Rating.find(params[:id])
    @rating.update_attribute('reported', '0')
    flash[:notice] = "Rating resetted."
    redirect_to(show_reported_rating_path(params[:id]))
  end
  
  def delete_rating
    @rating = Rating.find(params[:id])
    @rating.destroy
    
  end
  
  # GET /ratings/1
  # GET /ratings/1.json
  def show
  end

  # GET /ratings/new
  def new
    @rating = Rating.new
  end

  # GET /ratings/1/edit
  def edit
  end


  def create
      if session[:current_user_id] != nil 
        @user = User.find(session[:current_user_id])
        @review = Review.find(params[:review_id])
        @rating = @review.ratings.create(rating_params)
        @rating.user = @user
        @rating.save
        rating_user = User.find(@review.user_id)
        str = "You have a new Rating for your Review '" + @review.title + "'.<br>The Rating is: " + @rating.description + "<br>Please modify it."
        new_message_for_user(rating_user,"Wow! You have a new comment to your Review.",str,true)
        redirect_to review_path(@review)
      else
        #no user was loaded
        flash[:alert] = "You must have to login."
        redirect_to :back
      end
  end


  # PATCH/PUT /ratings/1
  # PATCH/PUT /ratings/1.json
  def update
    respond_to do |format|
      if @rating.update(rating_params)
        format.html { redirect_to @rating, notice: 'Rating was successfully updated.' }
        format.json { render :show, status: :ok, location: @rating }
      else
        format.html { render :edit }
        format.json { render json: @rating.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ratings/1
  # DELETE /ratings/1.json
  def destroy
    @rating.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Rating was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rating
      @rating = Rating.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rating_params
      params.require(:rating).permit(:review_id, :user_name, :point, :description, :rate_question1, :rate_question2, :rate_question3)
    end
end
