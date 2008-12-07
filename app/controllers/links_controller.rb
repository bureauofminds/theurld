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
      
      number_of_links = 0
      
      params[:link][:uri].each_line do |uri|
        MiddleMan.worker(:links_worker).async_new(:arg => {:uri => uri, :master_member_id => @master_member.id, :category_id => (@category ? @category.id : nil), :number_of_links => number_of_links})
        number_of_links += 1
      end
      
      if number_of_links < 1
        flash[:notice] = "No URLs were added"
      elsif number_of_links == 1 or params[:link][:quick]
        flash[:notice] = "URL added successfully"
      else
        flash[:notice] = "#{number_of_links} URLs added successfully"
      end
      
      redirect_to session[:referrer] || '/' and return
    end
  end
  
end
