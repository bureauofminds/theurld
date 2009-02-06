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
  
  map.connect '/members/:username', :controller => 'members', :action => 'view'
  map.connect '/members/:username/friends_urls', :controller => 'members', :action => 'friends_urls'
  map.connect '/members/:username/export_urls', :controller => 'members', :action => 'export_urls'
  map.connect '/members/:username/befriend', :controller => 'members', :action => 'befriend'
  map.connect '/members/:username/unfriend', :controller => 'members', :action => 'unfriend'
  
  # This should be of lowest priority (the below routes are the defaults from Rails)
  map.connect '/:code', :controller => 'links', :action => 'view'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
