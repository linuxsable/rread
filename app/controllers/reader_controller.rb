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

    r = {:success => true, :result => nil, :error => nil}

    if username.nil? or password.nil?
      r[:error] = 'missing params'
    end

    reader = current_user.reader
    result = reader.import_greader(username, password)

    if result.is_a? Array
      r[:error] = result
    else
      r[:success] = result
    end

    respond_to do |format|
      format.json { render :json => r }
    end
  end

  def mark_all_as_read
    confirm = params[:confirm]
    blog_id = params[:blog_id]

    r = { :success => false }

    if confirm
      r[:success] = current_user.reader.mark_all_as_read(blog_id)
    else
      r[:error] = "Must pass a 'confirm' param"
    end    

    respond_to do |format|
      format.json { render :json => r }
    end
  end

end
