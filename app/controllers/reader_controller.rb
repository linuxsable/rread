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

  def show
    user = current_user.user_model
    result = {:success => true, :count => 0, :articles => []}
    timestamp = params[:timestamp]

    if !timestamp.nil?
      result[:articles] = user.reader.article_feed(nil, nil, timestamp)
    else
      result[:articles] = user.reader.article_feed(50)
    end

    result[:count] = result[:articles].count

    respond_to do |format|
      format.json { render :json => result }
    end
  end
end
