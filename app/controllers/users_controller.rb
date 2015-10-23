class UsersController < ApplicationController
  
 http_basic_authenticate_with name: "r", password: "r", except: [:new, :update, :login, :login_attempt, :logout, :set_user, :index, :create, :update_user_location, :show]

  # GET /users
  # GET /users.json
  def index
    if session[:current_user_id] == 1
      @users = User.all
    else
      redirect_to(user_path(session[:current_user_id]))
    end
  end

  def logout
    @_curr_user_id =  session[:current_user_id] = nil
    session[:current_user_name] = nil
    session.delete(:current_user_name)
    session.delete(:current_user_id)
    session.delete(:current_user_lat)
    session.delete(:current_user_lon)
    redirect_to login_path
  end

  def login
    #Login Form
  end
  
  def update_user_location
    if params[:lat] != nil and
       params[:lon] != nil
       
       session[:current_user_lat] = params[:lat]
       session[:current_user_lon] = params[:lon]
       render :text => "Current user position: " + session[:current_user_lat] + " - " + session[:current_user_lon]
    else
      render :text => "No params"
    end
  end

  def login_attempt
    authorized_user = User.authenticate(params[:username_or_email],params[:login_password])
    if authorized_user
      flash[:success] = "Welcome, you logged in as #{authorized_user.user_name}"
      session[:current_user_id] = authorized_user.id
      session[:current_user_name] = authorized_user.user_name
    #  RatingmeMailer.register_email(authorized_user).deliver
      redirect_to reviews_path 
    else
      flash[:error] = "Invalid Username or Password"
      redirect_to(:action => 'login') #render "login"  
   end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    if session[:current_user_id] == params[:id]
      @user = User.find(params[:id])
    else
      @user = User.find(session[:current_user_id])
    end
    @ratings = @user.ratings.all
    @reviews = Review.all.where(:user_id => @user.id)
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
        format.html { redirect_to reviews_path, notice: 'User was successfully created.' }
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
