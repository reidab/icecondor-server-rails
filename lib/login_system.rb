module LoginSystem
  def self.included(base)
    base.send :helper_method, :logged_in?, :current_user
  end

  def logged_in?
    !current_user.nil?
  end

  def current_user
    session[:userid] = @current_user if @current_user # compatibility hack for oauth plugin
    session[:userid]
  end

  def current_user_openid=(openid)
    session[:userid] = openid
  end

  def login_required
    authorized? || access_denied
  end

  def authorized?
    logged_in?
  end

  def access_denied
    respond_to do |format|
      format.html do
        flash[:alert] = "Please login first"
        next_url = url_for :controller => :oauth, :action => :authorize,
                                         :oauth_token => params[:oauth_token]
        redirect_to :controller => :session, :action => :login_screen, :next_url => next_url
      end
      format.any(:json, :xml) do
        request_http_basic_authentication 'Web Password'
      end
    end
  end
end
