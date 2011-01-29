class FriendshipsController < ApplicationController
  def new
    @friendship = Friendship.new
  end

  def create
    current_user.friends << User.find(params[:friendship][:friend_id])
    redirect_to :controller => :users,
                :action => :show, :id => current_user.username
  end
end