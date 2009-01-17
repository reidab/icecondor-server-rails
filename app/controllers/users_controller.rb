class UsersController < ApplicationController
  def show
    user = User.find_by_username(params[:id])
    if user 
      if user == current_user
        render :action => :show_owner
      else
        render :action => :show_public
      end
    else
      flash[:error] = "#{params[:id]} has no profile data"
      redirect_to :root
    end
  end
end
