class NumenorController < ApplicationController
  
  def index
    @links = Link.find(:all,
                       :limit => 20)
    @categories = Category.find(:all,
                                :order => 'name ASC')
  end
  
end
