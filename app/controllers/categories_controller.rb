class CategoriesController < ApplicationController
  
  def view
    if params[:name].downcase == "uncategorized"
      @links = Link.paginate(:page => params[:page],
                             :conditions => 'category_id IS NULL',
                             :order => 'updated_on DESC')
    else
      @category = Category.find_by_name(params[:name])
      @links = @category.links.paginate(:page => params[:page],
                                        :order => 'updated_on DESC')

      # Auto-select this category in the quick_bar
      @link = Link.new
      @link.category_id = @category.id
    end
  end
  
end
