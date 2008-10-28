class DashboardController < ApplicationController
  def index
    @locations = Location.last_updates(2,10)
  end

end
