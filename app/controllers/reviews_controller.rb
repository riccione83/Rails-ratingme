class ReviewsController < ApplicationController
  include ApplicationHelper
  include ReviewsHelper
  skip_before_filter  :verify_authenticity_token
  before_action :set_review, only: [:show, :edit, :update, :destroy]

  # GET /reviews
  # GET /reviews.json
  def index
    
   if params[:search]
     @reviews = Review.search(params[:search]).order("created_at DESC")
   else
    if session[:current_user_lat] != nil
       city = [session[:current_user_lat],session[:current_user_lon]]
       @reviews = Review.near(city, 40, :units => :km)
    else
       @reviews = Review.last(5)
    end
   
    @hash = Gmaps4rails.build_markers(@reviews) do |review, marker|
      marker.lat review.latitude
      marker.lng review.longitude
      marker.title   review.title
      
      point =  self.get_avg_for_review(review)
      if point == 0
         marker.picture({
            :url     => 'assets/baloon_no_star.png',
            :width   => 32,
            :height  => 32
            })
      elsif point == 1
        marker.picture({
            :url     => 'assets/baloon_1_star.png',
            :width   => 32,
            :height  => 32
            })
      elsif point == 2
        marker.picture({
            :url     => 'assets/baloon_2_star.png',
            :width   => 32,
            :height  => 32
            })
      elsif point == 3
        marker.picture({
            :url     => 'assets/baloon_3_star.png',
            :width   => 32,
            :height  => 32
            })
      elsif point == 4
        marker.picture({
            :url     => 'assets/baloon_4_star.png',
            :width   => 32,
            :height  => 32
            })
     elsif point == 5
        marker.picture({
            :url     => 'assets/baloon_5_star.png',
            :width   => 32,
            :height  => 32
            })            
      end
      
      marker.infowindow render_to_string(partial: "/layouts/partial", locals: {info: review})
      marker.json({ :id => review.id, :foo => "bar" })
    end
  end
  end

  def gmaps4rails_infowindow
    @reviews = Gmaps.map.markers 
  end
  
  # GET /reviews/1
  # GET /reviews/1.json
  def show
    @review = Review.find(params[:id])
    @ratings = @review.ratings.all
  end

  # GET /reviews/new
  def new
    @review = Review.new
  end

  # GET /reviews/1/edit 
  def edit
  end

  # POST /reviews
  # POST /reviews.json
  def create
    @review = Review.new(review_params)

    respond_to do |format|
      if @review.save
        format.html { redirect_to @review, notice: 'Review was successfully created.' }
        format.json { render :json => '{"message":"created"}' } #render :show, status: :created, location: @review }
      else
        format.html { render :new }
        format.json { render :json => '{"message":"error"}' } #render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reviews/1
  # PATCH/PUT /reviews/1.json
  def update
    respond_to do |format|
      @review.picture = params[:picture]
      if @review.update(review_params)
        format.html { 
                        flash[:success] = "Review successfully updated!"
                        redirect_to @review 
                    }
        format.json { render :show, status: :ok, location: @review }
      else
        format.html { 
                        flash[:error] = "Unable to edit the review"
                        render :edit 
                    }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1
  # DELETE /reviews/1.json
  def destroy
    @review.destroy
    respond_to do |format|
      format.html { redirect_to reviews_url, notice: 'Review was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def review_params
      params.require(:review).permit(:user_id, :latitude, :longitude, :title, :description, :question1, :question2, :question3, :isAdvertisement, :adImageLink, :file, :picture)
    end
end
