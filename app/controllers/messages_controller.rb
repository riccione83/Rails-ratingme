class MessagesController < ApplicationController
    include MessagesHelper
    
    before_action :set_message, only: [:index, :destroy]
     
    def index
     
    end
    
    def new
        @message = Message.new
    end
    
    def new_message
        render :message => 'new_message', layout: false
        
    end
    
    def post_message_to_user
        if params[:user_id] != nil
            @user = User.find(params[:user_id])
        else
            @user = User.find(session[:current_user_id])
        end
        @to_user = User.find_by_user_name(params[:to_user_id])
        if @to_user != nil
            new_message_for_user(@to_user,"Message from: " + @user.user_name,params[:message],true)
            redirect_to reviews_path, notice: 'Message sent.'
        else
            flash[:error] = "Message not sent."
            redirect_to reviews_path
        end
    end
    
    def set_read
        @message = Message.find(params[:id])
        @message.status = 1
        @message.save!
        redirect_to :back
    end
    
    def destroy
       @message = Message.find(params[:id])
       @message.destroy
       respond_to do |format|
            format.html { redirect_to :back, notice: 'Message has been destroyed.' }
            format.json { head :no_content }
       end
    end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
        if params[:user_id] != nil
            @user = User.find(params[:user_id])
            @messages = @user.messages.order(:created_at)
        end
    end  
end