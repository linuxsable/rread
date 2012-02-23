class SubscriptionsController < ApplicationController
	def create
    reader = current_user.reader
    result = reader.add_subscription(params[:feed_url])

    respond_to do |format|
      format.json { render :json => { :success => result } }
    end
	end

  def destroy
    reader = current_user.reader
    result = reader.remove_subscription(params[:feed_url])

    respond_to do |format|
      format.json { render :json => { :success => result } }
    end
  end
end