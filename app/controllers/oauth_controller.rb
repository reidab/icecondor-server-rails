class OauthController < ApplicationController
  before_filter :login_required,:except=>[:request_token,:access_token,:test_request]
  before_filter :login_or_oauth_required,:only=>[:test_request]
  before_filter :verify_oauth_consumer_signature, :only=>[:request_token]
  before_filter :verify_oauth_request_token, :only=>[:access_token]
  # Uncomment the following if you are using restful_open_id_authentication
  # skip_before_filter :verify_authenticity_token

  def request_token
    @token=current_client_application.create_request_token
    if @token
      render :text=>@token.to_query
    else
      render :nothing => true, :status => 401
    end
  end 
  
  def access_token
    @token=current_token.exchange!
    if @token
      render :text=>@token.to_query
    else
      render :nothing => true, :status => 401
    end
  end

  def test_request
    render :text=>params.collect{|k,v|"#{k}=#{v}"}.join("&")
  end
  
  def authorize
    @token=RequestToken.find_by_token params[:oauth_token]
    unless @token.invalidated?    
      if request.post? 
        if params[:authorize]=='1'
          @token.authorize!(current_user)
          redirect_url=params[:oauth_callback]||@token.client_application.callback_url
          if redirect_url
            redirect_to redirect_url+"?oauth_token=#{@token.token}&openid=#{current_user.openidentities.first.url}"
          else
            render :action=>"authorize_success"
          end
        elsif params[:authorize]=="0"
          @token.invalidate!
          render :action=>"authorize_failure"
        end
      end
    else
      render :action=>"authorize_failure"
    end
  end
  
  def revoke
    @token=current_user.tokens.find_by_token params[:token]
    if @token
      @token.invalidate!
      flash[:notice]="You've revoked the token for #{@token.client_application.name}"
    end
    redirect_to oauth_clients_url
  end
  
  def connect #outbound oauth
    case params[:id]
    when "foursquare"
      cred = SETTINGS["foursquare"]["oauth"]
      oauth = Foursquare::OAuth.new(cred["key"], cred["secret"])
      # get the request token
      oauth.request_token(:oauth_callback => url_for(:controller => :oauth, :action => :foursquare_callback))
      session[:request_token] = oauth.request_token.token
      session[:request_secret] = oauth.request_token.secret
      redirect_to oauth.request_token.authorize_url
    end
  end

  def foursquare_callback
    cred = SETTINGS["foursquare"]["oauth"]
    oauth = Foursquare::OAuth.new(cred["key"], cred["secret"])
    access_token, access_secret = oauth.authorize_from_request(session[:request_token], session[:request_secret], params[:oauth_verifier])
    current_user.tokens.create(:type => :AccessToken, :token => access_token, :secret => access_secret, :client_application => ClientApplication.find_by_name("foursquare"))
    redirect_to :controller => :users, :action => current_user.username
  end
end
