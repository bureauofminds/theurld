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
  
  # Below methods are used to authorize access to development builds
  # The authorization code is stored as an MD5 hash in environment.rb
  
  def authorize
    if session[:authorized_for_development] == true
      flash[:notice] = "This computer is already authorized. If you would like to deauthorize this computer, <a href=\"/deauthorize\">click here</a>."
      redirect_to :action => 'index' and return
    else
      if request.post?
        if md5(params[:authorization][:code]) == DEVELOPMENT_AUTHORIZATION_CODE
          session[:authorized_for_development] = true
        
          flash[:notice] = "This computer has been authorized"
          redirect_to :action => 'index' and return
        else
          flash[:error] = "Wrong. This attempt has been logged and our goons are on their way to your house."
        end
      end
    
      render :layout => 'authorize'
    end
  end
  
  def deauthorize
    session[:authorized_for_development] = false
    
    flash[:notice] = "Deauthorized"
    redirect_to :action => 'authorize'
  end
  
end
