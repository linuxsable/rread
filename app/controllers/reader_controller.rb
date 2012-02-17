class ReaderController < ApplicationController
  def index
    user = current_user.user_model
    @user_feed = @current_user.user_model.friend_activity_feed
  end

  def show
    user = current_user.user_model
    result = {:success => true, :count => 0, :articles => []}
    timestamp = params[:timestamp]
    filter = (params[:source]) ? params[:source] : nil

    if !filter.nil? && !timestamp.nil?
      result[:articles] = user.reader.article_feed(nil, filter, timestamp)    
    elsif !filter.nil?
      result[:articles] = user.reader.article_feed(50, filter)
    elsif !timestamp.nil?
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
