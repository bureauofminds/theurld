ActionController::Routing::Routes.draw do |map|
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  map.connect '', :controller => 'numenor', :action => 'index'
  map.connect '/login', :controller => 'members', :action => 'login'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
