class Management::CategoriesController < Management::ApplicationController
  
  def index
  end
  
  def new
    case request.method
    when :get
      ###
    
    when :post
      @category = Category.new(params[:category])
      
      if @category.save
        flash[:notice] = "Category has been added successfully"
      else
        flash[:error] = "An error occured while creating the category. Please try again."
      end
      
      redirect_to :action => 'index'
    end
  end
  
end
