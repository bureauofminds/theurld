ActionController::Routing::Routes.draw do |map|
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  map.connect '', :controller => 'numenor', :action => 'index'
  map.connect '/login', :controller => 'members', :action => 'login'
  map.connect '/logout', :controller => 'members', :action => 'logout'
  map.connect '/register', :controller => 'members', :action => 'register'
  
  map.connect '/:code', :controller => 'links', :action => 'view'
  
  map.connect '/page/:page', :controller => 'numenor'
  
  map.connect '/category/:name', :controller => 'categories', :action => 'view'
  
  map.connect '/members/:id', :controller => 'members', :action => 'view'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
