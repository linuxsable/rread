class SubscriptionsController < ApplicationController
	def create
    result = {:success => true}

    begin
      reader = current_user.reader
      result[:success] = reader.add_subscription(params[:feed_url])  
    rescue Exception => e
      result[:success] = false
      result[:error] = e.message
    end

    respond_to do |format|
      format.json { render :json => result }
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