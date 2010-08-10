class LocationsController < ApplicationController

  def index #search
    @locations = []
    if params[:lat] && params[:long]
      #replace this with calculations of a bounding box/circle of radius r
      @locations = Location.find_all_by_geom([[params[:long].to_i-1,params[:lat].to_i-1],
                                              [params[:long].to_i+1,params[:lat].to_i+1],4326])
      render :text => @locations.to_json
    elsif params[:id]
      limit = params[:limit] ? params[:limit] : 10
      @user = User.find_by_openid(params[:id])
      if @user
        # access control
        if (@user.access_status == "public") || 
           (@user.access_status == "private" && @user == current_user)
          @locations = Location.find(:all, :conditions => {:user_id => @user.id}, 
                                         :order => 'timestamp desc', :limit => limit)
          @communicate = Location.find(:first, :conditions => {:user_id => @user.id},
                                         :order => 'id desc', :limit => 1)
        else
          flash[:notice] = "This user's location is private."
          redirect_to :controller => :session, :action => :login_screen
          return
        end
      else
        flash[:notice] = "Records for user #{params[:id]} were not found."
        redirect_to :root
        return
      end
    else
      @locations = Location.recent
    end
    @location_count = Location.count

    respond_to do |wants|
      wants.json { render :json => @locations }
      wants.jsonp { render :json => "#{params[:callback]}(#{@locations.to_json})" }
      wants.rss
      wants.html { render :layout => "googlemaps" }
    end
  end

  def watch #live
    @locations = []
    @user = User.find_by_openid(params[:id])
    if @user
      @locations = Location.all(:conditions => {:user_id => @user.id}, :order => 'id desc', :limit => 1)
    end
    respond_to do |wants|
      wants.html { render :layout => "googlemaps" }
    end
  end

  def mobile
    @user = User.find_by_openid(params[:id])
    if @user
      @location = Location.first(:conditions => {:user_id => @user.id}, 
                                 :order => 'timestamp desc')
    end
    respond_to do |wants|
      wants.html { render :layout => "googlemaps" }
    end
  end

  def daychart
    @user = User.find_by_openid(params[:id])
    if @user
      @period_end = Time.now.utc
      @period_start = @period_end - 1.day
      @period_difference = @period_end - @period_start
      @period = 5.minutes
      @periods = 1.day / @period
      @locations = Location.all(:conditions => 
                                  ["user_id = ? and timestamp >= ? and timestamp <= ?", 
                                   @user.id, @period_start, @period_end], :order => 'id desc')
      @buckets = Array.new(@periods,0)
      @locations.each do |location|
        bucket = ((location.timestamp - @period_start)/@period).floor
        @buckets[bucket] += 1
      end

      # communications
      @communications = Location.all(:conditions => 
                                     ["user_id = ? and created_at >= ? and created_at <= ?", 
                                      @user.id, @period_start, @period_end], :order => 'id desc')
      @cbuckets = Array.new(@periods,0)
      @communications.each do |communication|
        cbucket = ((communication.created_at - @period_start)/@period).floor
        @cbuckets[cbucket] += 1
      end
    end

    respond_to do |wants|
      wants.html 
    end
  end

  def new
    @location = Location.new
  end

  def create
    # support OAUTH and unauthenticated updates for now
    if params[:oauth_token] && oauthenticate
      token = OauthToken.find_by_token(params[:oauth_token])
      user = token.user
    else
      url = params[:location].delete(:guid)
      user = Openidentity.lookup_or_create(url).user
    end

    params[:location].merge!({:user => user})
    @location = Location.new(params[:location])
    saved = @location.save

    respond_to do |format|
      if saved
        flash[:notice] = "new location record saved."
        format.html { redirect_to locations_path }
        format.json { render :text => {:id => @location.id}.to_json }
      else
        format.html { render :action => "new" }
        format.json { render :text => "", :status => 500 }
      end
    end
  end

  def show
    location = Location.find(:first, :conditions => {:guid => params[:id]},
                                     :order => "created_at desc")
    render :text => location.to_json
  end
end
