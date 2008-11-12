class MembersController < ApplicationController
  
  def index
    @members = Member.find_all
  end
  
  def view
    @member = Member.find_by_username(params[:username])
    @links = @member.links.paginate(:page => params[:page],
                                    :order => 'updated_on DESC')
  end
  
  def friends_urls
    @member = Member.find_by_username(params[:username])
    
    # Angelo Ashmore, 11/10/08: this is a very inefficient process
    
    friends = YAML.load(@member.friends)
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
  
  def befriend
    @member = Member.find_by_username(params[:username])
    if @member == @master_member
      flash[:notice] = "You can't befriend yourself. Really, you can't."
    else
      existing_friends = YAML.load(@master_member.friends)

      if existing_friends.include?(@member.id)
        flash[:notice] = "You are already <em>great</em> friends with #{@member.username}"
      else
        existing_friends << @member.id
        @master_member.update_attribute('friends', YAML.dump(existing_friends))
      
        flash[:notice] = "You have just befriended #{@member.username}"
      end
    end
    
    redirect_to :action => 'view', :username => @member.username
  end
  
  def unfriend
    @member = Member.find_by_username(params[:username])
    if @member == @master_member
      flash[:notice] = "You can't unfriend yourself. Emo."
    else
      existing_friends = YAML.load(@master_member.friends)

      if existing_friends.include?(@member.id)
        existing_friends.delete(@member.id)
        @master_member.update_attribute('friends', YAML.dump(existing_friends))
      
        flash[:notice] = "#{@member.username} is no longer a friend. #{helpers.pronoun(@member, 'he_she').capitalize} must have done something bad&hellip;"
      else
        flash[:notice] = "Looks like you aren't friends with #{@member.username} to begin with"
      end
    end
    
    redirect_to :action => 'view', :username => @member.username
  end
  
  def edit
    if request.post?
      @member = Member.find_by_username(params[:username])
      
      if params[:member][:password]
        if params[:member][:password] == ""
          flash[:error] = "A blank password is not allowed. Please try again."
          redirect_to :action => 'view', :id => @member.id and return
        else
          params[:member][:password] = md5(params[:member][:password])
        end
        
        if @member.update_attributes(params[:member])
          flash[:notice] = "Password updated successfully."
        else
          flash[:error] = "A problem occured while updating your password. Please try again."
        end
      else
        if @member.update_attributes(params[:member])
          flash[:notice] = "Updated successfully."
        else
          flash[:error] = "A problem occured while updating your information. Please try again."
        end
      end
    end
    
    redirect_to :action => 'view', :username => @member.username
  end
  
  def delete
    if request.post?
      @member = Member.find_by_username(params[:username])
      
    end
  end
  
  def register
    if request.post?
      params[:member][:password] = md5(params[:member][:password])
      @member = Member.new(params[:member])
      existing_member = Member.find_by_username(@member.username)
      
      if existing_member
        flash[:error] = "A member with the username &quot;#{@member.username}&quot; already exists. Please chose a new, unique username." and return
      else
        @member.friends = YAML.dump([])
        @member.enemies = YAML.dump([])
        @member.save
        flash[:notice] = "Member &quot;#{@member.username}&quot; has been created successfully. You may now login."
        redirect_to :controller => 'members', :action => 'login'
      end
    end
  end
  
  def login
    if request.post?
      @member = Member.new(params[:member])
      existing_member = Member.find(:first,
                                    :conditions => ['username = ? AND password = ?', @member.username, md5(@member.password)])
      
      if existing_member
        session[:member_id] = existing_member.id
        session[:logged_in] = true
        # flash[:notice] = "Loggedin successfully."
        redirect_to session[:referrer] || '/' and return
      else
        flash[:notice] = "The username or password you specified is incorrect. Please try again."
        @member.password = nil
      end
    end
  end
  
  def logout
    session[:member_id] = nil
    session[:logged_in] = false
    if session[:logged_in] == false && session[:member_id] == nil
      flash[:notice] = "You have logged out."
      redirect_to :controller => '/'
    else
      flash[:notice] = "An error occured while logging out. Please try again."
      redirect_to :controller => '/'
    end
  end
  
end
