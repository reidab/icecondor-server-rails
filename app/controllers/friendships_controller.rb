class FriendshipsController < ApplicationController
  def new
    @friendship = Friendship.new
  end

  def create
    username, domain = params[:email].split('@')
    case domain
    when "icecondor.com"
      friend = User.find_by_username(username)
    else
      begin
        finger = Redfinger.finger(params[:email])
      rescue Redfinger::ResourceNotFound => e
        flash[:error] = "webfinger err: #{e}"
      rescue SocketError => e
        flash[:error] = "#{identifier}: #{e}"
      end
    end

    if friend
      current_user.friends << friend
      redirect_to :controller => :users,
                :action => :show, :id => current_user.username
    else
      redirect_to :action => :new
    end
  end
end