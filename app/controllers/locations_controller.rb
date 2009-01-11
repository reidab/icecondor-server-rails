class LocationsController < ApplicationController

  def index #search
    if params[:lat] && params[:long]
      #replace this with calculations of a bounding box/circle
      #of radius r
      @locations = Location.find_all_by_geom([[params[:long].to_i-1,params[:lat].to_i-1],
                                              [params[:long].to_i+1,params[:lat].to_i+1],4326])
      render :text => @locations.to_json
    elsif params[:id]
      limit = params[:limit] ? params[:limit] : 10
      user_id = Openidentity.find_by_url(params[:id])
      if user_id
        @locations = Location.find(:all, :conditions => {:user_id => user_id}, 
                                       :order => 'id desc', :limit => limit)
      else
        @locations = []
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
    guid = params[:location].delete(:guid)
    @openid = Openidentity.find_by_url(guid)
    if @openid
      userid = @openid.user_id
    else
      user = User.create
      userid = user.id
      Openidentity.create(:url => guid, :user => user)
    end
    params[:location].merge!({:user_id => userid})
    logger.info params.inspect
    @location = Location.new(params[:location])
    saved = @location.save
    if request.xhr?
      head(saved ? :ok : :bad_request)
    else
      if saved
        flash[:notice] = "new location record saved."
        redirect_to locations_path
      else
        render :action => "new"
      end
    end
  end

  def show
    location = Location.find(:first, :conditions => {:guid => params[:id]},
                                     :order => "created_at desc")
    render :text => location.to_json
  end
end
