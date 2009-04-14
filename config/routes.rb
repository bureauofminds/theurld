ActionController::Routing::Routes.draw do |map|
  map.connect ':controller/service.wsdl', :action => 'wsdl'
  
  # Remove when in production
  map.connect '/authorize', :controller => 'numenor', :action => 'authorize'
  map.connect '/deauthorize', :controller => 'numenor', :action => 'deauthorize'

  map.connect '', :controller => 'numenor', :action => 'index'
  map.connect '/login', :controller => 'members', :action => 'login'
  map.connect '/logout', :controller => 'members', :action => 'logout'
  map.connect '/register', :controller => 'members', :action => 'register'
  map.connect '/settings', :controller => 'members', :action => 'settings'
  
  map.connect '/page/:page', :controller => 'numenor'
  map.connect '/friends_urls', :controller => 'numenor', :action => 'friends_urls'
  
  map.connect '/category/:name', :controller => 'categories', :action => 'view'
  map.connect '/category/:name/friends_urls', :controller => 'categories', :action => 'friends_urls'
  
  map.connect '/links/queue/:id/:index', :controller => 'links', :action => 'process_queue'
  
  map.connect '/members/:username', :controller => 'members', :action => 'view'
  map.connect '/members/:username/friends_urls', :controller => 'members', :action => 'friends_urls'
  map.connect '/members/:username/export', :controller => 'members', :action => 'export'
  map.connect '/members/:username/befriend', :controller => 'members', :action => 'befriend'
  map.connect '/members/:username/unfriend', :controller => 'members', :action => 'unfriend'
  
  # Management
  map.connect '/management', :controller => 'management/management'
  map.connect '/management/categories', :controller => 'management/categories'
  map.connect '/management/members/edit/:username', :controller => 'management/members', :action => 'edit'
  
  # This should be of lowest priority (the below routes are the defaults from Rails)
  map.connect '/:code', :controller => 'links', :action => 'view'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
