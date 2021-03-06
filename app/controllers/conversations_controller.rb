class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_resource, except: [:new, :create]
  
  def new
    @conversation = Message.new
  end
  
  def show
    # mark conversation as read
    unless current_user.is_admin?
      @conversation.mark_as_read(current_user)
    end
  end
  
  def create
    @conversation = current_user.sent_messages.build(conversation_params)
    
    if @conversation.save
      flash[:notice] = "Your message was successfully sent!"
      redirect_to mailbox_inbox_path
    else
      flash[:alert] = @conversation.errors.full_messages.to_sentence
      render :action => "new"
    end
  end
  
  def edit
    
  end
  
  def update
    @conversation = Message.find(params[:id])
    authorize! :update, @conversation
    if @conversation.update_attributes(conversation_params) 
      flash[:notice] = "Your message was successfully updated!"
      redirect_to mailbox_inbox_path
    else
      flash[:alert] = @conversation.errors.full_messages.to_sentence
      render :action => "edit"
    end
  end
  
  def destroy
    @conversation = Message.find(params[:id])
    authorize! :destroy, @conversation
    if @conversation.destroy
      flash[:notice] = "Your message was successfully deleted!"
      redirect_to mailbox_inbox_path
    else
      flash[:alert] = @conversation.errors.full_messages.to_sentence
      render :action => "show"
    end
      
  end
  
  private
  
  def find_resource
    @conversation = Message.find(params[:id])
  end

  def conversation_params
    params.require(:message).permit(:subject, :body, :to)
  end
end