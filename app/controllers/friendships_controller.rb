class FriendshipsController < ApplicationController
  def new
    @friendship = Friendship.new
  end

  def create
    accturl = "acct:#{params[:email]}"
    oid = Openidentity.lookup_or_create(accturl)
    friend = oid.user
    
    begin
      #finger = Redfinger.finger(params[:email])
      #url = finger.relmap('http://locationcommons.org/spec/1.0#at').first.href
      #uri = URI.parse(url)
    rescue Redfinger::ResourceNotFound => e
      flash[:error] = "webfinger err: #{e}"
    rescue SocketError => e
      flash[:error] = "#{identifier}: #{e}"
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