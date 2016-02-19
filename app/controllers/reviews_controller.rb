class ReviewsController < ApplicationController
  include ApplicationHelper
  include ReviewsHelper
  include MessagesHelper
  
  skip_before_filter  :verify_authenticity_token
  before_action :set_review, only: [:show, :edit, :update, :destroy]
  before_action :check_login, only: [:index]
  
  # GET /reviews
  # GET /reviews.json
  def index
    if( session[:current_user_id] == nil)
      redirect_to login_path
    else    
      if params[:search] and params[:search] != ""
          @reviews = Review.search(params[:search]).paginate(page: params[:page], per_page: 10).order("created_at DESC").where.not(reported: "1")
      else
        if session[:current_user_lat] != nil
          city = [session[:current_user_lat],session[:current_user_lon]]
          @reviews = Review.near(city, 200, :units => :km).paginate(page: params[:page], per_page: 10).order("created_at DESC").where.not(reported: "1")
          @near_you = Review.near(city, 2, :units => :km).limit(5).order("created_at DESC").where.not(reported: "1")
        else
          @reviews = Review.all.paginate(page: params[:page], per_page: 10).order("created_at DESC").where.not(reported: "1")
        end
      end
      buildMaker(@reviews)
    end
  end
  
  def show_reported_review
     @reviews = Review.all.paginate(page: params[:page], per_page: 10).order("created_at DESC").where.not(reported: "0")
  end
  
  def report_review
    @review = Review.find(params[:id])
    @review.update_attribute('reported', '1')
    @user = User.find(@review.user_id)
    RatingmeMailer.reported_review(@user,@review).deliver_now
    new_message_for_user(@user,"Someone has reported your Review. Please login and modify it.","Someone has reported that your Review contain inappropriate material.<br>The Review is titled: " + @review.title + "<br>Please modify it.",true)
    flash[:notice] = "Review reported. Thankyou."
    redirect_to(review_path(params[:id]))
  end
  
  def reset_review
    @review = Review.find(params[:id])
    @review.update_attribute('reported', '0')
    flash[:notice] = "Review resetted."
    redirect_to(show_reported_review_path(params[:id]))
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
      @ratings = @review.ratings.all.paginate(page: params[:page], per_page: 10).where.not(reported: "1")
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
    @near_reviews = Review.near(city, 0.010, :units => :km)
    if @near_reviews.any?
       respond_to do |format|
         format.html { 
                        flash[:error] = "There is another Review at this point. Please try again in another location. Thankyou."
                        redirect_to @review 
                     }
         format.json { render :json => '{"error":"There is another Review at this point. Please try again in another location. Thankyou."}' }
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

    def check_login
      if session[:current_user_id] == nil
        if(cookies.signed[:current_user_id])
          authorized_user = User.find(cookies.signed[:current_user_id])
          if authorized_user
            session[:current_user_id] = authorized_user.id
            session[:current_user_name] = authorized_user.user_name
          end
        end
      end
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def review_params
      params.require(:review).permit(:user_id, :latitude, :longitude, :title, :description, :question1, :question2, :question3, :isAdvertisement, :adImageLink, :file, :picture)
    end
end
