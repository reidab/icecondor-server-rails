module SessionSpecHelper
  def login(user)
    controller.stub!(:current_user).and_return(user)
    User.stub!(:find_by_openid).with(user.openidentities.first.url).and_return(user)
  end
end
