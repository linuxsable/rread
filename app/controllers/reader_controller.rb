class ReaderController < ApplicationController
  def index
    user = current_user.user_model

    # Handle the filter
    filter = params[:f]

    if filter.nil?
      user.reader.async_all_subscriptions
    end

    @user_feed = @current_user.user_model.friend_activity_feed
    @article_feed = current_user.reader.article_feed(30, filter)
  end
end
