class ReaderController < ApplicationController
  def index
    user = current_user.user_model
    @user_feed = Activity.feed_for_user(user)
    @article_feed = current_user.reader.article_feed
    user.reader.async_all_subscriptions
  end
end
