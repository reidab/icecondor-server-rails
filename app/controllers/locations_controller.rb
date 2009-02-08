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
           (@user.access_status == "protected" && @user == current_user)
          @locations = Location.find(:all, :conditions => {:user_id => @user.id}, 
                                         :order => 'id desc', :limit => limit)
        else
          flash[:notice] = "This user's location is protected."
          redirect_to :controller => :session, :action => :login_screen
          return
        end
      end
    else
      @locations = Location.recent
    end
    @location_count = Location.count

    respond_to do |wants|
      wants.json { render :json => @locations }
      wants.xml { render :xml => @locations }
      wants.html { render :layout => "googlemaps" }
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
