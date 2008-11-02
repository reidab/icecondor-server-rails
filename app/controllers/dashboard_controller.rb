class DashboardController < ApplicationController
  def index
    @locations = Location.last_updates(3,10)
  end

end
