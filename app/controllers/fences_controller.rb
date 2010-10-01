class FencesController < ApplicationController
  def new
    respond_to do |wants|
      wants.html { }
    end
  end

  def create
    points = params[:points].map{|sp| sp.split(',').map{|sp|sp.to_f}}
    logger.info(points.inspect)
    # close the ring
    points << points.first
    wgs84_srid = 4326
    current_user.fences.create(:name => params[:fence][:name],
                               :geom => Polygon.from_coordinates([points], wgs84_srid, true))
    redirect_to :controller => :users, :action => :show, :id => current_user.username
  end

  def destroy
    Fence.find(params[:id]).destroy
    redirect_to({:controller => :users, :action => :show, :id => current_user.username})
  end
end
