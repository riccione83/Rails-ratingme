class CategoriesController < ApplicationController
    
    before_action :set_category, only: [:destroy, :show, :edit, :update, :destroy]

    def index
        @categories = Category.all
    end
    
 # GET /users/1
  # GET /users/1.json
  def show
    
  end

  # GET /users/new
  def new
    @category = Category.new
  end

  # GET /users/1/edit
  def edit
    
  end

  # POST /users
  # POST /users.json
  def create
    
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        format.html { render :index, notice: 'A new category was successfully created.' }
        format.json { render :index, status: :created, location: @category }
      else
        format.html { render :new }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { render :index, notice: 'Category was successfully updated.' }
        format.json { render :index, status: :ok, location: @category }
      else
        format.html { render :edit }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy

    @category.destroy
    respond_to do |format|
      format.html { redirect_to categories_url, notice: 'Category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
        @category = Category.find(params[:id])
    end    
   
     def category_params
      params.require(:category).permit(:id, :description, :image)
    end 
end