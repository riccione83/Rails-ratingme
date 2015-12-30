class ReviewsController < ApplicationController
  include ApplicationHelper
  include ReviewsHelper
  skip_before_filter  :verify_authenticity_token
  before_action :set_review, only: [:show, :edit, :update, :destroy]

  # GET /reviews
  # GET /reviews.json
  def index
    if params[:search] and params[:search] != ""
        @reviews = Review.search(params[:search]).order("created_at DESC").paginate(page: params[:page], per_page: 10)
    else
      if session[:current_user_lat] != nil
         city = [session[:current_user_lat],session[:current_user_lon]]
         @reviews = Review.near(city, 30, :units => :km).paginate(page: params[:page], per_page: 10)
      else
         @reviews = Review.all.paginate(page: params[:page], per_page: 10)
      end
    end
   buildMaker(@reviews)
  end

  def buildMaker(rev)
    @hash = Gmaps4rails.build_markers(rev) do |review, marker|
      marker.lat review.latitude
      marker.lng review.longitude
      marker.title   review.title
      
      point =  self.get_avg_for_review(review)
      
        marker.picture({
            :url     => '/assets/baloon_no_star.png',
            :width   => 32,
            :height  => 32
            }) if point == 0
        marker.picture({
            :url     => '/assets/baloon_1_star.png',
            :width   => 32,
            :height  => 32
            }) if point == 1
        marker.picture({
            :url     => '/assets/baloon_2_star.png',
            :width   => 32,
            :height  => 32
            }) if point == 2
        marker.picture({
            :url     => '/assets/baloon_3_star.png',
            :width   => 32,
            :height  => 32
            }) if point == 3
        marker.picture({
            :url     => '/assets/baloon_4_star.png',
            :width   => 32,
            :height  => 32
            }) if point == 4
        marker.picture({
            :url     => '/assets/baloon_5_star.png',
            :width   => 32,
            :height  => 32
            }) if point == 5
      
      marker.infowindow render_to_string(partial: "/layouts/partial", locals: {info: review})
      marker.json({ :id => review.id, :foo => "bar" })
    end
  end


  def gmaps4rails_infowindow
    @reviews = Gmaps.map.markers 
  end
  
  # GET /reviews/1
  # GET /reviews/1.json
  def show
    if params[:id] != nil
      @review = Review.find(params[:id])
      @ratings = @review.ratings.all
      buildMaker(@review)
    end
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
    
    city = [session[:current_user_lat],session[:current_user_lon]]
    @near_reviews = Review.near(city, 0.10, :units => :km)
    if @near_reviews.any?
       respond_to do |format|
         format.html { 
                        flash[:error] = "There is another review at this point"
                        redirect_to @review 
                     }
         format.json { render :json => '{"error":"There is another review at this point."}' }
      end
    else
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
