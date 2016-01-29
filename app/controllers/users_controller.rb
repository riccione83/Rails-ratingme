class UsersController < ApplicationController
  
 http_basic_authenticate_with name: "r", password: "r", except: [:new,:edit, :update, :login, :login_attempt,:report_user, :login_from_social, :logout, :set_user, :index, :create, :update_user_location, :update_user_radius, :show]

  # GET /users
  # GET /users.json
  def index
    if session[:current_user_id] == 1
      @users = User.all
    else
      redirect_to(user_path(session[:current_user_id]))
    end
  end

  def show_reported_user
     @users = User.all.paginate(page: params[:page], per_page: 10).where.not(reported: "0")
  end
  
  def report_user
    @user = User.find(params[:id])
    @user.update_attribute('reported', '1')
    flash[:notice] = "Utente segnalato. Grazie."
    redirect_to(user_path(params[:id]))
  end
  
  def reset_user
    @user = User.find(params[:id])
    @user.update_attribute('reported', '0')
    flash[:notice] = "Utente Ripristinato"
    redirect_to(user_path(params[:id]))
  end
  
  def login_from_social
    #puts "ENVIRONMENT: "
    #puts env["omniauth.auth"]
    session[:user_reported] = "0"	
    user = User.from_omniauth(env["omniauth.auth"])
    if user.is_a? String
      flash[:alert] = user
      redirect_to login_path
    else
      if user.reported == '1'
        flash[:alert] = "Hi #{user.user_name}, someone has reported that you have some Review that don't respect our user agreement. Your account is blocked and you cannot create new Review or Rating. Please contact us to unlock your account."
        session[:user_reported] = "1"
      end
      session[:current_user_id] = user.id
      session[:current_user_name] = user.user_name
      redirect_to start_path
    end
  end
  
  def logout
    @_curr_user_id =  session[:current_user_id] = nil
    session[:current_user_name] = nil
    session.delete(:current_user_name)
    session.delete(:current_user_id)
    session.delete(:current_user_lat)
    session.delete(:current_user_lon)
    session.delete(:user_reported)
    redirect_to login_path
  end
  
  def login
    #Login Form
  end
  
  def update_user_radius
    if params[:rad] != nil
      session[:user_radius] = params[:rad]
      render :text => "View for radius: " + params[:rad]
    end
  end
  
  def update_user_location
    if params[:lat] != nil and
       params[:lon] != nil
       
       session[:current_user_lat] = params[:lat]
       session[:current_user_lon] = params[:lon]
       render :text => "Current user position: " + session[:current_user_lat] + " - " + session[:current_user_lon]
      # redirect_to reviews_path
    else
      render :text => "No params"
    end
  end

  def login_attempt
    authorized_user = User.authenticate(params[:username_or_email],params[:login_password])
    if authorized_user
      if authorized_user.reported == '1'
        flash[:alert] = "Hi #{authorized_user.user_name}, someone has reported that you have some Review that don't respect our user agreement. Your account is blocked and you cannot create new Review or Rating. Please contact us to unlock your account."
        session[:user_reported] = "1"        
      else
        flash[:success] = "Welcome, you logged in as #{authorized_user.user_name}"
        session[:user_reported] = "0"
      end
      session[:current_user_id] = authorized_user.id
      session[:current_user_name] = authorized_user.user_name
     # RatingmeMailer.register_email(authorized_user).deliver_now   #disable this
      redirect_to start_path 
    else
      flash[:error] = "Invalid Username or Password"
      redirect_to(:action => 'login') #render "login"  
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @ratings = @user.ratings.all
    @reviews = Review.all.where(:user_id => @user.id)
    
   #if session[:current_user_id] == params[:id]
   #   @user = User.find(params[:id])
   # else
   #   @user = User.find(session[:current_user_id])
   # end
   # @ratings = @user.ratings.all
   # @reviews = Review.all.where(:user_id => @user.id)
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        session[:current_user_id] = @user.id
        session[:current_user_name] = @user.user_name
        RatingmeMailer.register_email(@user).deliver_now
        format.html { redirect_to start_path, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
        
    @ratings = @user.ratings.all
    @reviews = Review.all.where(:user_id => @user.id)
    @ratings.delete_all
    @reviews.delete_all
  
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
        @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:id, :user_name, :user_password_hash, :user_email, :user_city, :user_password_hash_confirmation)
    end
end
