class NumenorController < ApplicationController
  
  def index
    @links = Link.find(:all,
                       :order => 'updated_on DESC',
                       :limit => 20)
    @categories = Category.find(:all,
                                :conditions => 'subcategory = 0',
                                :order => 'name ASC')
    @subcategories = Category.find(:all,
                                   :conditions => 'subcategory = 1',
                                   :order => 'name ASC')
  end
  
end
