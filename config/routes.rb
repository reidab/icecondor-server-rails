ActionController::Routing::Routes.draw do |map|
  map.resources :locations
  map.resources :users
  map.root :controller => "dashboard", :action => "map"

  # Watch
  map.watch '/watch',:controller=>'locations',:action=>'watch'
  # Mobile
  map.m '/m',:controller=>'locations',:action=>'mobile'
  # Day Chart
  map.daychart '/daychart',:controller=>'locations',:action=>'daychart'
  map.totalupdatecount '/totalupdatecount',:controller=>'locations',:action=>'totalupdatecount'
  map.totalupdatecount '/totaluserscount',:controller=>'locations',:action=>'totaluserscount'

  # OAUTH plugin routes
  map.oauth '/oauth',:controller=>'oauth',:action=>'index'
  map.authorize '/oauth/authorize',:controller=>'oauth',:action=>'authorize'
  map.request_token '/oauth/request_token',:controller=>'oauth',:action=>'request_token'
  map.access_token '/oauth/access_token',:controller=>'oauth',:action=>'access_token'
  map.test_request '/oauth/test_request',:controller=>'oauth',:action=>'test_request'
  map.oauth_clients '/oauth_clients',:controller=>'oauth',:action=>'clients_list'

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
