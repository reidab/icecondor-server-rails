ActionController::Routing::Routes.draw do |map|
  map.resources :locations
  map.root :controller => "dashboard"

  # OAUTH plugin routes
  map.oauth '/oauth',:controller=>'oauth',:action=>'index'
  map.authorize '/oauth/authorize',:controller=>'oauth',:action=>'authorize'
  map.request_token '/oauth/request_token',:controller=>'oauth',:action=>'request_token'
  map.access_token '/oauth/access_token',:controller=>'oauth',:action=>'access_token'
  map.test_request '/oauth/test_request',:controller=>'oauth',:action=>'test_request'

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
