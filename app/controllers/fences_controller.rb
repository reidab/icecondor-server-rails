class FencesController < ApplicationController
  WGS84_SRID = 4326
  def new
    @fence = Fence.new
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
    begin
      fence = current_user.fences.create!(:name => params[:fence][:name],
                                 :geom => Polygon.from_coordinates([points], WGS84_SRID, true))
      redirect_to :controller => :users, :action => :show, :id => current_user.username
    rescue ActiveRecord::RecordInvalid => e
      flash[:error] = "#{e}"
      redirect_to :action => :new
    end
  end

  def edit
    @fence = Fence.find(params[:id].to_i)
  end

  def update
    points = params[:points].map{|sp| sp.split(',').map{|sp|sp.to_f}}
    # close the ring
    points << points.first
    fence = Fence.find(params[:id].to_i)
    fence.update_attributes(:name => params[:fence][:name],
                            :geom => Polygon.from_coordinates([points], WGS84_SRID, true))
    redirect_to user_path(current_user.username)
  end

  def destroy
    current_user.fences.find(params[:id]).destroy
    redirect_to({:controller => :users, :action => :show, :id => current_user.username})
  end
end
