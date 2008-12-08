class LinksController < ApplicationController
  
  def view
    @link = Link.find_by_code(params[:code])
    redirect_to @link.uri
  end
  
  def new
    case request.method
    when :get
      ###
    
    when :post
      @category = Category.find(params[:category][:id]) unless params[:category][:id].length < 1
      
      index = 0
      start_time = Time.now
      workers = []
      
      params[:link][:uri].each_line do |uri|
        # create a new process for each uri
        workers << MiddleMan.new_worker(:worker => "links_worker",
                                        :data => {:uri => uri,
                                                  :master_member_id => @master_member.id,
                                                  :category_id => (@category ? @category.id : nil)})
        index += 1
      end
      
      if index < 1
        flash[:notice] = "No URLs were added"
      elsif index == 1 or params[:link][:quick]
        flash[:notice] = "URL added successfully"
      else
        flash[:notice] = "#{index} URLs added successfully"
      end
      
      redirect_to session[:referrer] || '/' and return
    end
  end
  
end
