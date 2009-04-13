class Management::MembersController < Management::ApplicationController
  
  def index
    @members = Member.find(:all,
                           :order => 'username ASC')
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
      
      @member = Member.new(params[:member])
      
      @members = Member.find(:all,
                             :conditions => ['username LIKE ? AND first_name LIKE ? AND last_name LIKE ? AND email_address LIKE ?',
                                             "%#{@member.username}%",
                                             "%#{@member.first_name}%",
                                             "%#{@member.last_name}%",
                                             "%#{@member.email_address}%"])
    end
  end
  
end
