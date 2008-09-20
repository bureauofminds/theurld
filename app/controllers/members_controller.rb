class MembersController < ApplicationController
  
  def index
    @members = Member.find_all
  end
  
  def view
    @member = Member.find(params[:id])
  end
  
  def edit
    if request.post?
      @member = Member.find(params[:id])
      
      if params[:member][:password]
        if params[:member][:password] == ""
          flash[:error] = "A blank password is not allowed. Please try again."
          redirect_to :action => 'view', :id => @member.id and return
        else
          params[:member][:password] = Digest::MD5.hexdigest(params[:member][:password])
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
    
    redirect_to :action => 'view', :id => @member.id
  end
  
  def delete
    if request.post?
      @member = Member.find(params[:id])
      
    end
  end
  
  def new
    if request.post?
      params[:member][:password] = Digest::MD5.hexdigest(params[:member][:password])
      @member = Member.new(params[:member])
      existing_member = Member.find_by_username(@member.username)
      
      if existing_member
        flash[:error] = "A member with the username &quot;#{@member.username}&quot; already exists. Please chose a new, unique username." and return
      else
        @member.save
        flash[:notice] = "Member &quot;#{@member.username}&quot; has been added successfully."
        redirect_to :action => 'view', :id => @member.id
      end
    end
  end
  
  def login
    if request.post?
      @member = Member.new(params[:member])
      existing_member = Member.find(:first,
                                    :conditions => ['username = ? AND password = ?', @member.username, Digest::MD5.hexdigest(@member.password)])
      
      if existing_member
        session[:member_id] = existing_member.id
        session[:logged_in] = true
        flash[:notice] = "Loggedin successfully."
        redirect_to session[:referrer] || '/' and return
      else
        flash[:notice] = "The username or password you specified is incorrect. Please try again."
      end
    end
  end
  
  def logout
    session[:member_id] = nil
    session[:logged_in] = false
    if session[:logged_in] == false && session[:member_id] == nil
      flash[:notice] = "You have logged out."
      redirect_to :action => 'login'
    else
      flash[:notice] = "An error occured while logging out. Please try again."
      redirect_to :controller => '/'
    end
  end
  
end
