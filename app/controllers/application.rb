# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  before_filter :adjust_format_for_iphone


  # Use our standard layout for all non-AJAX/non-RSS-feed requests
  layout proc {|c| (c.request.xhr? || c.request.format.to_s.include?("xml")) ? false : "standard-layout" }

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  #protect_from_forgery # :secret => 'e9f400a335857817f3a6191387175b57'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  def adjust_format_for_iphone    
    request.format = Mime::Type.lookup_by_extension("iphone") if iphone_user_agent?
    logger.info "new format "+request.format.class.name+" "+request.format
  end

  # Request from an iPhone or iPod touch? (Mobile Safari user agent)
  def iphone_user_agent?
    !(request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(Mobile\/.+Safari)/]).nil?
  end
end
