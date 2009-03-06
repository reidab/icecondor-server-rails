class DashboardController < ApplicationController
  def index
  end

  def map
    @last_users_reporting = Location.last_users_reporting(5)
    @locations = Location.last_updates(@last_users_reporting,3)
  end

  def users
    @last_users_reporting = Location.last_users_reporting(5)
    @locations = Location.last_updates(@last_users_reporting,1)
  end

end
