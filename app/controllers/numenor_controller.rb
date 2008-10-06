class NumenorController < ApplicationController
  
  def index
    @links = Link.find(:all,
                       :order => 'updated_on DESC',
                       :limit => 20)
  end
  
end
