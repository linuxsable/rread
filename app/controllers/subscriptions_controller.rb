class SubscriptionsController < ApplicationController
	def create
    @reader = current_user.reader
    @reader.add_subscription(params[:feed_url])
	end

  def destroy
    @reader = current_user.reader
    @reader.remove_subscription(params[:feed_url])
  end
end