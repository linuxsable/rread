# This will be for logged in users only
class HomeController < ApplicationController
  def index
    if signed_in?
      return redirect_to :controller => 'reader', :action => 'index'
    end

    render :layout => 'static'
  end

end