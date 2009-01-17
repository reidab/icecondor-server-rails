require File.dirname(__FILE__) + '/../spec_helper'

describe UsersController do
  include SessionSpecHelper
  fixtures :users

  it "should display the owner page for owners" do
    user = users(:quentin)
    login(user)
    get :show, :id => user.username
    response.should render_template('users/show_owner')
  end

  it "should display the public page for visitors" do
    user = users(:quentin)
    login(user)
    get :show, :id => users(:danny).username
    response.should render_template('users/show_public')
  end
end
