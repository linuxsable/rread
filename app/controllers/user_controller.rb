class UserController < ApplicationController
  def index
    user = current_user.user_model
    @user_feed = Activity.feed_for_user(user)
  end
end
