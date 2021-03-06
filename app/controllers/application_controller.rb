class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :check_onboarding_status
  
  # Make these avail to the views as helpers
  helper_method :current_user, :signed_in?
  
  protected
  
  # Get the current user
  def current_user
    if @current_user
      @current_user
    else
      User.find_by_id(cookies[:user_id])
    end
  end
  
  # Assign current user and set session
  def current_user=(user)
    @current_user = user
    cookies[:user_id] = user.id
  end

  # Is current user signed in
  def signed_in?
    !!current_user
  end

  def check_onboarding_status
    @controller_name = controller_name
    @action_name = action_name

    return if !signed_in?

    if @controller_name == 'sessions' and @action_name == 'index'
      return
    end

    if !current_user.onboarded?
      return redirect_to :controller => 'sessions', :action => 'index'
    end
  end

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "thatshit" && password == "cray"
    end
  end
end
