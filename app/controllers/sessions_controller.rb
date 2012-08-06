class SessionsController < ApplicationController
  # This will handle the stage between creating an account
  # and accepting terms and small settings before starting.
  def index
    current_user.onboard!

    render :layout => 'index'
  end

  def create
    auth = request.env['omniauth.auth']
    unless @auth = Authorization.find_from_hash(auth)
      # Create a new user or add an auth to existing user, depending on
      # whether there is already a user signed in.
      @auth = Authorization.create_from_hash(auth, current_user)
    end

    user = @auth.user
    user.async_facebook_friends
    
    # Log the authorizing user in.
    self.current_user = user

    if user.onboarded?
      return redirect_to :controller => 'reader'
    else
      return redirect_to :controller => 'sessions', :action => 'index'
    end
  end

  def destroy
    cookies[:user_id] = nil
    redirect_to :controller => 'home'
  end
end
