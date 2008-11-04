ActionController::Routing::Routes.draw do |map|
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  map.connect '', :controller => 'numenor', :action => 'index'
  map.connect '/login', :controller => 'members', :action => 'login'
  
  map.connect '/:code', :controller => 'links', :action => 'view'
  
  map.connect '/page/:page', :controller => 'numenor'
  
  map.connect '/category/:id', :controller => 'categories', :action => 'view'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
