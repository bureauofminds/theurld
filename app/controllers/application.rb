# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_Numenor_session_id'
  
  require 'will_paginate'
  
  before_filter :setup
  before_filter :svn_info
  
  def md5(input)
    Digest::MD5.hexdigest(input.to_s)
  end
  
  def setup
    unless ['login', 'logout', 'register'].include?(params[:action])
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
  
  def svn_info
    @svn_info = YAML.load(`svn info`)
  end
  
  # user Application helpers in the controllers
  def helpers
    Helper.instance
  end
  
  class Helper
    include Singleton
    include ApplicationHelper
  end
end
