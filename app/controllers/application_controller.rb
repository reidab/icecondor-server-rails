# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  include LoginSystem
  include XrdsHeader
  include ExceptionNotification::Notifiable
  
  protected
  def validate_id_as_username
    @user = User.find_by_username(params[:id])
    if @user 
      return true
    else
      flash[:error] = "#{params[:id]} is an unknown identity"
      redirect_to :root
    end
  end
end

