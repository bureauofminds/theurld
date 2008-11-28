class Management::MembersController < Management::ApplicationController
  
  def index
    @members = Member.find(:all,
                           :order => 'username ASC')
  end
  
end
