class UsersController < ApplicationController
  def show
    user = User.find_by_username(params[:id])
    unless user 
      flash[:error] = "#{params[:id]} has no profile data"
      redirect_to :root
    end
  end
end
