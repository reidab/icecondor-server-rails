class FencesController < ApplicationController
  def new
    respond_to do |wants|
      wants.html { }
    end
  end

  def create
    unless params[:points]
      redirect_to :action => :new
      flash[:error] = "Please mark the corners of the fence."
      return
    end
    points = params[:points].map{|sp| sp.split(',').map{|sp|sp.to_f}}
    # close the ring
    points << points.first
    wgs84_srid = 4326
    begin
      fence = current_user.fences.create!(:name => params[:fence][:name],
                                 :geom => Polygon.from_coordinates([points], wgs84_srid, true))
      redirect_to :controller => :users, :action => :show, :id => current_user.username
    rescue ActiveRecord::RecordInvalid => e
      flash[:error] = "#{e}"
      redirect_to :action => :new
    end
  end

  def destroy
    current_user.fences.find(params[:id]).destroy
    redirect_to({:controller => :users, :action => :show, :id => current_user.username})
  end
end
