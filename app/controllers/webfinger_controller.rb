class WebfingerController < ApplicationController
  layout nil

  def xrd
    username = params[:acct].split('@').first
    logger.info("looking up username #{username}")
    @user = User.find_by_username(username)
    render :status => 404, :nothing => true unless @user
  end
end