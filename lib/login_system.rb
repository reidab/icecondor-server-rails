module LoginSystem
  protected
  def self.included(base)
    base.send :helper_method, :logged_in?, :current_user
  end

  def logged_in?
    !current_user.nil?
  end

  def current_user
    User.find_by_id(session[:userid])
  end

  def current_user=(user)
    case user
    when Fixnum
      session[:userid] = user
    when User
      session[:userid] = user.id
    end
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
        # ruby 1.8 hack, select does not return a hash
        oauth_extras = params.reject{|k,v| !k.match(/^oauth/)}
        next_url = url_for({:controller => :oauth, :action => :authorize}.merge(oauth_extras))
        redirect_to :controller => :session, :action => :login_screen, :next_url => next_url
      end
      format.any(:json, :xml) do
        request_http_basic_authentication 'Web Password'
      end
    end
  end
end
