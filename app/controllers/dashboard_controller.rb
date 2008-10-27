class DashboardController < ApplicationController
  def index
    @locations = Location.last_updates(5,4)
  end

end
