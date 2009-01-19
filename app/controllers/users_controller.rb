class UsersController < ApplicationController
  before_filter :validate_id_as_username
  def show
  end
end
