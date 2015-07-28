class Management::ManagementController < Management::ApplicationController
  
  def index
    @members = Member.find_all
    @superusers = Member.find(:all,
                              :conditions => ['superuser = ?', 1])
    
    @categories = Category.find_all
  end
  
end
