class LoginController < ApplicationController
  include OpenidUtility

  def index
    if request.post?
      begin
        params[:openid_identifier]
        identifier = params[:openid_identifier]
        if identifier.nil?
          flash[:error] = "Enter an OpenID identifier"
          redirect_to :root
          return
        end
        idreq = consumer.begin(identifier)
      rescue OpenID::OpenIDError => e
        flash[:error] = "Discovery failed for #{identifier}: #{e}"
        redirect_to :root
        return
      end


    end
  end
end
