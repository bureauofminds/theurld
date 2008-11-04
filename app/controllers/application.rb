# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_Numenor_session_id'
  
  require 'will_paginate'
  
  before_filter :setup
  
  def md5(input)
    Digest::MD5.hexdigest(input.to_s)
  end
  
  def setup
    unless ['login', 'logout'].include?(params[:action])
      @master_member = Member.find(session[:member_id]) if session[:logged_in] == true
      session[:referrer] = request.request_uri
    end
    
    @categories = Category.find(:all,
                                :conditions => 'subcategory = 0',
                                :order => 'name ASC')
    @subcategories = Category.find(:all,
                                   :conditions => 'subcategory = 1',
                                   :order => 'name ASC')
  end
end
