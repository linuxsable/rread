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

  def recent_articles
    user = current_user.user_model
    timestamp = params[:timestamp]

    result = {:success => true, :articles => [], :count => 0}

    if !timestamp.nil?
      result[:articles] = user.reader.article_feed(nil, nil, timestamp)
      result[:count] = result[:articles].count  
    end

    respond_to do |format|
      format.json { render :json => result }
    end

  end
end
