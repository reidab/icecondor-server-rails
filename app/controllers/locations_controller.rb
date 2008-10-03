class LocationsController < ApplicationController

  def index #search
    if params[:lat] && params[:long]
      #replace this with calculations of a bounding box/circle
      #of radius r
      @locations = Location.find_all_by_geom([[params[:long].to_i-1,params[:lat].to_i-1],
                                              [params[:long].to_i+1,params[:lat].to_i+1],4326])
      render :text => @locations.to_json
    end
    @location_count = Location.count
  end

  def create
    location = Location.new(:guid => params[:location][:guid],
                            :geom => Point.from_x_y_z(params[:location][:longitude],
                                                      params[:location][:latitude],
                                                      params[:location][:altitude],
                                                      4326))
    location.save!
    if request.xhr?
      head :ok
    else
      flash[:notice] = "new location record saved."
      redirect_to locations_path
    end
  end

  def show
    location = Location.find(:first, :conditions => {:guid => params[:id]},
                                     :order => "created_at desc")
    render :text => location.to_json
  end
end
