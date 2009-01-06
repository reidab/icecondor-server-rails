module LoginSystem
  def self.included(base)
    base.send :helper_method, :logged_in?, :current_user
  end

  def logged_in?
    !session[:userid].nil?
  end

  def current_user
    session[:userid]
  end

  def login(openid)
    session[:userid] = openid
  end

end
