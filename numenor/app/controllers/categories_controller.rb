class CategoriesController < ApplicationController
  
  def view
    if params[:name].downcase == "uncategorized"
      @category = Category.new
      @category.name = "Uncategorized"
      
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
  
  def friends_urls
    friends = YAML.load(@master_member.friends)
    @friends = []
    friends.each { |f| @friends << Member.find(f) }
    @links = []
    
    if params[:name].downcase == "uncategorized"
      @category = Category.new
      @category.name = "Uncategorized"
      
      @friends.each do |f|
        f.links.find(:all, :conditions => 'category_id IS NULL').each do |l|
          @links << l
        end
      end
    else
      @category = Category.find_by_name(params[:name])
      
      @friends.each do |f|
        f.links.find(:all, :conditions => ['category_id = ?', @category.id]).each do |l|
          @links << l
        end
      end

      # Auto-select this category in the quick_bar
      @link = Link.new
      @link.category_id = @category.id
    end
    
    @links = @links.sort_by { |l| l.created_on }
    @links = @links.reverse.paginate(:page => params[:page])
  end
  
end
