class GmapsController < ApplicationController

  def index
    location = Location.find(:first, :conditions => {:guid => params[:id]},
                                     :order => "id desc")
    redirect_to "http://maps.google.com/maps?ll=#{location.geom.y},#{location.geom.x}"
  end

end
