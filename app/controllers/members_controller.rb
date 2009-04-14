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
      
        flash[:notice] = "&hearts; You have just befriended #{@member.username}"
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
  
  def export
    # Angelo 02/06/09 - Need to make this export to CSV, TXT, or something
    
    @member = Member.find_by_username(params[:username])
    
    urls = ""
    @member.links.each { |l| urls << "#{l.uri}<br/>\n" }
    
    render :text => urls
  end
  
  def settings
    # needed for form
    @member = @master_member
    
    if request.post?
      # don't allow username changes
      params[:member].delete('username')
      
      # if no new password, remove it from the param so it doesn't get updated
      if params[:member][:password].empty?
        params[:member].delete('password')
      else
        md5(params[:member][:password])
      end
      
      unless params[:member][:avatar_file] == ""
        require 'RMagick'
        
        Dir.mkdir(AVATAR_ROOT) unless File.exists?(AVATAR_ROOT)
        
        data = params[:member][:avatar_file]
        
        if data.content_type.starts_with?('image')
          original_filename = data.original_filename
          temporary_file = File.join(AVATAR_ROOT, @master_member.id.to_s + ".temp" + File.extname(original_filename))
          final_file = File.join(AVATAR_ROOT, @master_member.id.to_s + ".gif")

          File.open(temporary_file, 'w') { |f| f.write(data.read) }

          img = Magick::Image.read(temporary_file).first
          thumb = img.scale(16, 16)
          thumb.write(final_file)

          File.delete(temporary_file)

          params[:member][:avatar] = true
        else
          data = nil
          avatar_error = "Your avatar, however, was not a valid image."
        end
      end
      
      params[:member].delete('avatar_file')
      
      if @master_member.update_attributes(params[:member])
        unless avatar_error
          flash[:notice] = "Updated successfully."
        else
          flash[:notice] = "Updated successfully. Your avatar, however, was not a valid image type."
        end
      else
        params[:member][:password] = nil
        flash[:error] = "A problem occured while updating your information. Please try again."
      end
    end
  end
  
  def register
    if request.post?
      params[:member][:password] = md5(params[:member][:password])
      @member = Member.new(params[:member])
      existing_member = Member.find_by_username(@member.username)
      
      if existing_member
        @member.password = nil
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
        flash[:error] = "The username or password you specified is incorrect. Please try again."
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
      flash[:error] = "An error occured while logging out. Please try again."
      redirect_to :controller => '/'
    end
  end
  
end
