class NumenorController < ApplicationController
  
  def index
    @links = Link.paginate(:page => params[:page],
                           :order => 'updated_on DESC')
  end
  
end
