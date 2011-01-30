class WebfingerController < ApplicationController
  layout nil

  def xrd
    @user = User.find_by_username(params[:acct].split('@').first)
    render :status => 404, :nothing => true unless @user
  end
end