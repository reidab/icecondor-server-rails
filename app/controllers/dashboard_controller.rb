class DashboardController < ApplicationController
  def index
    @locations = Location.recent
  end

end
