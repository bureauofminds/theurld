class NumenorController < ApplicationController
  
  def index
    @links = Link.paginate(:page => params[:page],
                           :order => 'updated_on DESC')
  end
  
  def friends_urls
    # Angelo Ashmore, 11/10/08: this is a very inefficient process
    
    friends = YAML.load(@master_member.friends)
    @friends = []
    friends.each { |f| @friends << Member.find(f) }
    
    @links = []
    @friends.each do |f|
      f.links.each do |l|
        @links << l
      end
    end
    
    @links = @links.sort_by { |l| l.created_on }
    @links = @links.reverse.paginate(:page => params[:page])
  end
  
end
