class ReaderController < ApplicationController
  def index
    user = current_user.user_model

    # Handle the filter
    filter = params[:f]

    if filter.nil?
      user.reader.async_all_subscriptions
    end

    @user_feed = Activity.feed_for_user(user)
    @article_feed = current_user.reader.article_feed(100, filter)
  end
end
