# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # Use our standard layout for all non-AJAX/non-RSS-feed requests
  layout proc {|c| (c.request.xhr? || c.request.format.to_s.include?("xml")) ? false : "standard-layout" }

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  #protect_from_forgery # :secret => 'e9f400a335857817f3a6191387175b57'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  include LoginSystem

end
