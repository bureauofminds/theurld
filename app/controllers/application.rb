# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_Numenor_session_id'
  
  require 'will_paginate'
  
  # keep out the mere mortals!
  # delete this when we go into production, of course
  before_filter :authorize_development_build, :except => 'authorize'
  
  before_filter :setup
  before_filter :save_referrer, :except => ['login', 'logout', 'register']
  before_filter :svn_info
  
  def authorize_development_build
    unless session[:authorized_for_development] == true
      flash[:notice] = "This is a private development build of The Urld. You aren't allowed in. <em>Or aRe YoU?</em>"
      redirect_to :controller => 'numenor', :action => 'authorize' and return false
    end
  end
  
  def is_superuser?
    redirect_to :controller => '/' unless @master_member.superuser?
  end
  
  def md5(input)
    Digest::MD5.hexdigest(input.to_s)
  end
  
  def setup
    @master_member = Member.find(session[:member_id]) if session[:logged_in] == true
    
    @categories = Category.find(:all,
                                :conditions => 'subcategory = 0',
                                :order => 'name ASC')
    @subcategories = Category.find(:all,
                                   :conditions => 'subcategory = 1',
                                   :order => 'name ASC')
  end
  
  def save_referrer
    # not an elegant solution to excluding a certain controller and action
    controler_action_exceptions = [['links', 'new'],
                                   ['numenor', 'view']]
    
    unless controler_action_exceptions.include?([params[:controller], params[:action]])
      session[:referrer] = request.request_uri
    end
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
