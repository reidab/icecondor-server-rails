class DashboardController < ApplicationController
  def index
    @last_users_reporting = Location.last_users_reporting(5)
    @locations = Location.last_updates(@last_users_reporting,3)
  end

end
