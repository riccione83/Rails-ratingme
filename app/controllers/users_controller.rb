class UsersController < ApplicationController

 http_basic_authenticate_with name: "r", password: "r", except: [:new, :update]
 before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  def logout
    @_curr_user_id =  session[:current_user_id] = nil
    session[:current_user_name] = nil
    redirect_to login_path
  end

  def login
    #Login Form
  end

  def login_attempt
    authorized_user = User.authenticate(params[:username_or_email],params[:login_password])
    if authorized_user
      flash[:success] = "Welcome, you logged in as #{authorized_user.user_name}"
      session[:current_user_id] = authorized_user.id
      session[:current_user_name] = authorized_user.user_name
      redirect_to(:action => 'index')
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
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        #format.html { redirect_to @user, notice: 'User was successfully created.' }
        session[:current_user_id] = @user.id
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
      params.require(:user).permit(:id, :user_name, :user_password_hash, :user_email, :user_city)
    end
end
