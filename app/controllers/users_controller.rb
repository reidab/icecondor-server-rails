class UsersController < ApplicationController
  before_filter :validate_id_as_username
  def show
  end

  def update
    user = User.find_by_username(params[:id])
    if user && user == current_user
      user.update_attribute :access_status, params[:user][:access_status]
      flash[:notice] = "Access status updated to "+params[:user][:access_status]
      redirect_to :action => :show, :id => current_user.username
    end
  end
end
