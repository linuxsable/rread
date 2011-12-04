class ApplicationController < ActionController::Base
  protect_from_forgery
  
  protected
  
  # Get the current user
  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end
  
  # Assign current user and set session
  def current_user=(user)
    @current_user = user
    session[:user_id] = user.id
  end

  # Is current user signed in
  def signed_in?
    !!current_user
  end
  
  # Make these avail to the views as helpers
  helper_method :current_user, :signed_in?
end
