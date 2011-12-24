class SessionsController < ApplicationController
  def create
    auth = request.env['omniauth.auth']
    unless @auth = Authorization.find_from_hash(auth)
      # Create a new user or add an auth to existing user, depending on
      # whether there is already a user signed in.
      @auth = Authorization.create_from_hash(auth, current_user)

      # Sync his facebook friends
      app_user = AppUser.new(@auth.user)
      app_user.sync_facebook_friends
    else
      app_user = AppUser.new(@auth.user)
      app_user.sync_facebook_friends_delayed
    end
    
    # Log the authorizing user in.
    self.current_user = @auth.user
    
    redirect_to :controller => 'index'
  end

  def destroy
    session[:user_id] = nil
    redirect_to :controller => 'index'
  end
end
