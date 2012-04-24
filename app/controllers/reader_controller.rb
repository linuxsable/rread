class ReaderController < ApplicationController
  def index
    @user_feed = current_user.friend_activity_feed
  end

  def show
    reader = current_user.reader
    reader.async_all_subscriptions

    result = {:success => true, :count => 0, :articles => []}

    timestamp = params[:timestamp]
    filter = params[:source]

    result[:articles] = reader.article_feed(100, filter, timestamp)
    result[:count] = result[:articles].count

    respond_to do |format|
      format.json { render :json => result }
    end
  end

  def import_greader
    username = params[:username]
    password = params[:password]

    @success = false
    @result = nil
    @error = nil

    if username.nil? or password.nil?
      @error = 'Missing params.'
      return
    end
    
    result = current_user.reader.import_greader(username, password)

    if result.is_a? Array
      @error = result
    else
      @result = result
    end
  end

  def mark_all_as_read
    @success = false
    @result = nil
    @error = nil

    if params[:confirm]
      @result = current_user.reader.mark_all_as_read(params[:blog_id])
      if !@result
        @error = 'Something went wrong.'
      else
        @success = true
      end
    else
      @error = "Must pass a 'confirm' param"
    end
  end

  # The main method of returning articles in
  # date order for the reader
  def article_feed
    reader = current_user.reader

    # This is a temp way of putting the reader
    # blogs on the q for syncing
    reader.async_all_subscriptions

    timestamp = params[:timestamp]
    filter = params[:source]
    count = params[:count] || 25

    @articles = reader.article_feed(count, filter, timestamp)
  end

end
