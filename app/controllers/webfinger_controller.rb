class WebfingerController < ApplicationController
  layout nil

  def xrd
    @user = User.find_by_openid(params[:id])
    render :status => 404, :nothing => true
  end
end