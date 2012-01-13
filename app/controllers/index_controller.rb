# Non-logged in user, splash page, login page, etc
class IndexController < ApplicationController
  def index
    @user_feed = []
  end
end
