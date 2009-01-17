module SessionSpecHelper
  def login(user)
    controller.stub!(:current_user).and_return(user)
    User.stub!(:find_by_username).with(user.username).and_return(user)
  end
end
