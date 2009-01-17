require File.dirname(__FILE__) + '/../spec_helper'

describe UsersController do
  include SessionSpecHelper
  fixtures :users

  it "should display the owner page for owners" do
    user = users(:quentin)
    login(user)
    get :show, :id => user.username
    response.should render_template('users/show')
  end

end
