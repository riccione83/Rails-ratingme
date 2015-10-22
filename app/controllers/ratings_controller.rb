class RatingsController < ApplicationController
  before_action :set_rating, only: [:show, :edit, :update, :destroy]

  # GET /ratings
  # GET /ratings.json
  def index
    @review = Review.find(params[:review_id])
    @ratings = @review.ratings.all
    @user = @ratings.first.user
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
