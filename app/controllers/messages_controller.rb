class MessagesController < ApplicationController
    before_action :set_message, only: [:index, :destroy]
     
    def index
     
    end
    
    def new
        @message = Message.new
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
            @messages = @user.messages
        end
    end  
end