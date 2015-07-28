class MessagesController < ApplicationController
  
  def index
    @messages = @master_member.messages.paginate(:page => params[:page],
                                                 :order => 'created_on DESC')
  end
  
  def view
    @message = @master_member.messages.find(params[:id])
  end
  
  def new
    if request.post?
      @message = Message.create(params[:message])
    end
  end
  
end
