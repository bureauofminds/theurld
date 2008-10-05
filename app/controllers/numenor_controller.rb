class NumenorController < ApplicationController
  
  def index
    @links = Link.find(:all,
                       :order => 'updated_on DESC',
                       :limit => 20)
    @categories = Category.find(:all,
                                :order => 'name ASC')
  end
  
end
