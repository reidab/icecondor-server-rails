class LocationsController < ApplicationController

  def index
    @location_count = Location.count
  end

  def create
    location = Location.new(:guid => params[:location][:guid],
                            :geom => Point.from_x_y_z(params[:location][:long],
                                                      params[:location][:lat],
                                                      params[:location][:altitude],
                                                      4326))
    location.save!
    flash[:notice] = "new location record saved."
    redirect_to locations_path

  end

  def show
    location = Location.find(:first, :conditions => {:guid => params[:id]},
                                     :order => "created_at desc")
    render :text => location.to_json
  end
end
