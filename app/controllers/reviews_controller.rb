class ReviewsController < ApplicationController
  before_action :set_review, only: [:show, :edit, :update, :destroy]

  #binding.pry

  # GET /reviews
  # GET /reviews.json
  def index
    city = request.remote_ip
    @reviews = Review.near(getInformation(city).coordinates, 2000, :units => :km)
   
    @hash = Gmaps4rails.build_markers(@reviews) do |review, marker|
      marker.lat review.latitude
      marker.lng review.longitude
      marker.title   review.title
      if review.title.include? "secondo"
         marker.picture({
            :url     => 'assets/star.png',
            :width   => 32,
            :height  => 32
            })
      else
        marker.picture({
            :url     => 'assets/star_red.png',
            :width   => 32,
            :height  => 32
            })
      end
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
        format.json { render :show, status: :created, location: @review }
      else
        format.html { render :new }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reviews/1
  # PATCH/PUT /reviews/1.json
  def update
    respond_to do |format|
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
      params.require(:review).permit(:user_id, :latitude, :longitude, :title, :description, :question1, :question2, :question3, :isAdvertisement, :adImageLink)
    end
end
