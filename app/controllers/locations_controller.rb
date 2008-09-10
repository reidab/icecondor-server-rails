class LocationsController < ApplicationController

  def index
    @location_count = Location.count
  end

  def create
    location = Location.new(:guid => params[:location][:guid],
                            :geom => Point.from_x_y_z(params[:location][:long],
                                                      params[:location][:lat],
                                                      100,123))
    location.save!
    flash[:notice] = "new location record saved."
    redirect_to locations_path

  end

  def show
    location = Location.find_by_guid(params[:id])
    render :text => location.to_json
  end
end
