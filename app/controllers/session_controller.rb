class SessionController < ApplicationController
  include OpenidUtility

  def login
    begin
      identifier = params[:openid_identifier]
      if identifier =~ RFC822::EMAIL
        # email
        finger = Redfinger.finger(identifier)
        openid_url = finger.open_id.first.to_s
      else
        # URL
        openid_url = params[:openid_identifier]
      end
      if openid_url.nil?
        flash[:error] = "Enter an OpenID identifier"
        redirect_to :root
        return
      end
      oidreq = consumer.begin(openid_url)
    rescue OpenID::OpenIDError => e
      flash[:error] = "Discovery failed for #{identifier}: #{e}"
      redirect_to :root
      return
    end
    return_to = url_for :action => 'complete', :only_path => false, :next_url => params[:next_url]
    realm = root_url

    if oidreq.send_redirect?(realm, return_to, params[:immediate])
      redirect_to oidreq.redirect_url(realm, return_to, params[:immediate])
    else
      render :text => oidreq.html_markup(realm, return_to, params[:immediate], {'id' => 'openid_form'})
    end
  end

  def complete
    # FIXME - url_for some action is not necessarily the current URL.
    current_url = url_for(:action => 'complete', :only_path => false)
    parameters = params.reject{|k,v|request.path_parameters[k]}
    oidresp = consumer.complete(parameters, current_url)
    case oidresp.status
    when OpenID::Consumer::FAILURE
      if oidresp.display_identifier
        flash[:error] = ("Verification of #{oidresp.display_identifier}"\
                         " failed: #{oidresp.message}")
      else
        flash[:error] = "Verification failed: #{oidresp.message}"
      end
    when OpenID::Consumer::SUCCESS
      flash[:success] = ("Verification of #{oidresp.display_identifier}"\
                         " succeeded.")
      user = Openidentity.lookup_or_create(oidresp.display_identifier).user
      self.current_user = user
    when OpenID::Consumer::SETUP_NEEDED
      flash[:alert] = "Immediate request failed - Setup Needed"
    when OpenID::Consumer::CANCEL
      flash[:alert] = "OpenID transaction cancelled."
    else
    end
    redirect_to (params[:next_url] || :root)
  end

  def logout
    reset_session
    flash[:notice] = "logged out"
    redirect_to :root
  end

end
