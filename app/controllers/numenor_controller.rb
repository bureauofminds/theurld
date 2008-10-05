class NumenorController < ApplicationController
  
  def index
    @links = Link.find(:all,
                       :limit => 20)
  end
  
end
