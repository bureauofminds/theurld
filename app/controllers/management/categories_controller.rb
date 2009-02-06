class Management::CategoriesController < Management::ApplicationController
  
  def index
  end
  
  def new
    case request.method
    when :get
      ###
    
    when :post
      if params[:category][:id].empty?
        @category = Category.new(params[:category])
        
        existing_category = Category.find_by_name(@category.name)
        if existing_category
          flash[:error] = "A category with the name \"#{@category.name}\" already exists. Please chose a new, unique name."
          redirect_to :action => 'index' and return 
        end

        if @category.save
          flash[:notice] = "Category has been added successfully"
        else
          flash[:error] = "An error occured while creating the category. Please try again."
        end
      else
        @category = Category.find(params[:category][:id])
        
        @subcategory = @category.subcategories.create(params[:category])
        
        if @subcategory
          flash[:notice] = "Subcategory has been added successfully"
        else
          @category = Category.new(params[:category])
          flash[:error] = "An error occured while creating the subcategory. Please try again."
        end
      end
      
      redirect_to :action => 'index'
    end
  end
  
end
