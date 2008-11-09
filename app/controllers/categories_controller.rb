class CategoriesController < ApplicationController
  
  def view
    @category = Category.find_by_name(params[:name])
    @links = @category.links.paginate(:page => params[:page],
                                      :order => 'updated_on DESC')
    
    # Auto-select this category in the quick_bar
    @link = Link.new
    @link.category_id = @category.id
  end
  
end
