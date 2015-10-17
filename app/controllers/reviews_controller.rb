class ReviewsController < ApplicationController
  before_action :set_review, only: [:show, :edit, :update, :destroy]

  #binding.pry

  # GET /reviews
  # GET /reviews.json
  def index
    city = request.remote_ip
    @reviews = Review.near(getInformation(city).coordinates)
   
    @hash = Gmaps4rails.build_markers(@reviews) do |review, marker|
      marker.lat review.latitude
      marker.lng review.longitude
    #  marker.infowindow render_to_string(:partial => "/users/my_template", :locals => review)
    #  marker.picture({
    #              :url    => "https://www.google.it/url?sa=i&rct=j&q=&esrc=s&source=images&cd=&cad=rja&uact=8&ved=0CAcQjRxqFQoTCJ7tnt-NysgCFYKCGgoda9QI5A&url=http%3A%2F%2Fwww.softicons.com%2Fsocial-media-icons%2Fsocial-media-icons-by-denis-abdullin%2Fgithub-icon&psig=AFQjCNEbUdGyTk-LVE5Pf73NlHr5-ktV3Q&ust=1445191961015269",
    #              :width  => "32",
    #              :height => "32"
    #             })
      marker.title   review.title
      marker.json({:id => review.id })
    end
    
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
