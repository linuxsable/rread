class ReaderController < ApplicationController
  def index
    user = current_user.user_model
    @user_feed = @current_user.user_model.friend_activity_feed
  end

  def show
    user = current_user.user_model
    result = {:success => true, :count => 0, :articles => []}

    timestamp = params[:timestamp]
    filter = params[:source]

    result[:articles] = user.reader.article_feed(100, filter, timestamp)
    result[:count] = result[:articles].count

    respond_to do |format|
      format.json { render :json => result }
    end
  end
end
