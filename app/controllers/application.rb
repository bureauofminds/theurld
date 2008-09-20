# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_Numenor_session_id'
  
  before_filter :setup, :except => ['login', 'logout']
  before_filter :save_referrer, :except => ['login', 'logout']
  
  def setup
    @master_member = Member.find(session[:member_id]) if session[:logged_in] == true
  end
  
  def save_referrer
    session[:referrer] = request.request_uri
  end
end
