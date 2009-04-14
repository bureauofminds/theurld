class Management::MembersController < Management::ApplicationController
  
  def index
    @members = Member.find(:all,
                           :order => "#{params[:sort] or "username"} #{params[:order] or "ASC"}")
  end
  
  def edit
    @member = Member.find_by_username(params[:username])
    
    if request.post?
      params[:member][:password] = md5(params[:member][:password])
      if @member.update_attributes(params[:member])
        flash[:notice] = "Member &quot;#{@member.username}&quot; has been updated successfully."
        redirect_to :action => 'index'
      else
        flash[:notice] = "An error occured while updating the user. Please try again."
      end
    end
  end
  
  def new
    @member = Member.new
    
    # taken from :controller => 'member', :action => 'register'
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
        flash[:notice] = "Member &quot;#{@member.username}&quot; has been created successfully."
        redirect_to :action => 'index'
      end
    end
  end
  
  def search
    case request.method
    when :get
      redirect_to :action => 'index'
    
    when :post
      # add wildcards to each field
      # params[:member].each_with_index do |v, i|
      #   params[:member][i][1] = "%#{v[1]}%"
      # end
      
      @query = Member.new(params[:query])
      
      @members = Member.find(:all,
                             :conditions => ["username LIKE ? AND first_name LIKE ? AND last_name LIKE ? AND email_address LIKE ?#{" AND superuser = 1" if @query.superuser == 1}",
                                             "%#{@query.username}%",
                                             "%#{@query.first_name}%",
                                             "%#{@query.last_name}%",
                                             "%#{@query.email_address}%"])
    end
  end
  
end
