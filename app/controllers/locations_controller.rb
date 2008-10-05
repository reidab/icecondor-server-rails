class LocationsController < ApplicationController

  def index #search
    if params[:lat] && params[:long]
      #replace this with calculations of a bounding box/circle
      #of radius r
      @locations = Location.find_all_by_geom([[params[:long].to_i-1,params[:lat].to_i-1],
                                              [params[:long].to_i+1,params[:lat].to_i+1],4326])
      render :text => @locations.to_json
    else
      @locations = Location.find(:all)
    end
    @location_count = Location.count
    @new_location = Location.new
  end

  def new
    @location = Location.new
  end

  def create
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
