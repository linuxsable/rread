# High level user of our system. This will hold all high level methods
# and talk directly to models.
#
# TODO:
# - Cache the shit out of getters
# - Optimize quieries
# - Probably should put friendship creation from import into models
class AppUser
  def initialize(user)
    if !user.is_a? User
      raise "'user' must be a User obj"
    end
    
    @user_model = user
    @provider_info_model = nil
    @facebook_api = nil
  end
  
  def id
    @user_model.id
  end
  
  def avatar
    load_provider_model
    @provider_info_model.avatar
  end
  
  def name
    load_provider_model
    @provider_info_model.first_name+' '+@provider_info_model.last_name
  end
  
  def email
    load_provider_model
    @provider_info_model.email
  end
  
  # Get the users friends.
  def friends
    output = []
    @user_model.friendships.each do |f|
      output << self.class.new(f.friend)
    end
    output
  end
  
  # Get inverse friends (people who've added this user).
  def inverse_friends
    output = []
    @user_model.inverse_friendships.each do |f|
      output << self.class.new(f.user)
    end
    output
  end
  
  # Get mutual friends.
  def mutual_friends
    # I don't like this
    f = friends
    f.zip(inverse_friends).flatten.compact
    f
  end
  
  # Are you friends with another AppUser?
  def friend?(app_user)
    if !app_user.is_a? AppUser
      raise "'app_user' must be a AppUser obj"
    end
    
    result = @user_model.friendships.where(:friend_id => app_user.id).first
    !result.nil?
  end
  
  # Is the other guy a friend of yours?
  def inverse_friend?(app_user)
    if !app_user.is_a? AppUser
      raise "'app_user' must be a AppUser obj"
    end
    
    result = Friendship.where(:user_id => app_user.id, :friend_id => self.id).first
    !result.nil?
  end
  
  # Are you friends with another AppUser
  # and are they friends with you?
  def mutual_friend?(app_user)
    if !app_user.is_a? AppUser
      raise "'app_user' must be a AppUser obj"
    end
    
    friend?(app_user) and inverse_friend?(app_user)
  end
  
  # This actually goes through the whole process of
  # importing facebook friends mutually for the user.
  # That means that it will create friendships for the current
  # user AND the friend.
  #
  # This should be run as a delayed job on registration
  # and subsequent logins to ensure friends are kept up
  # to date.
  #
  # Currently I do not know how efficent this is as no
  # DB optimizations have been done.
  def sync_facebook_friends
    find_facebook_friends_with_accounts.each do |auth|
      temp = self.class.new(auth)
      
      if !friend?(temp)
        Friendship.create! do |f|
          f.user_id = self.id
          f.friend_id = temp.id
        end
      end
      
      # Create the inverse friendship to save
      # extra db taxes later when the user logs in
      if !inverse_friend?(temp)
        Friendship.create! do |f|
          f.user_id = temp.id
          f.friend_id = self.id
        end
      end
    end
  end

  def sync_facebook_friends_delayed
    sync_facebook_friends
  end
  handle_asynchronously :sync_facebook_friends_delayed, :priority => 0
  
  def reader
    @user_model.readers.first
  end
  
  # This should probably get moved to a
  # "Reader" class later.
  def import_google_reader(email, password)
    creds = { :email => email, :password => password }
    
    reader = GReader.auth(creds)
    reader.feeds.each do |feed|
      # Import the feeds here
      Rails.logger.debug feed
    end
  end
  
  private
  
  # This helps to lazy load the provder model only if it's
  # needed by getters of this class.
  #
  # TODO: When we have more providers, this will have to be updated.
  def load_provider_model
    @provider_info_model ||= @user_model.provider_infos.first
  end
  
  # Search the users facebook friends to see which ones
  # have internal accounts with us. This is used for the
  # import process.
  def find_facebook_friends_with_accounts
    load_facebook_api
    friends = @facebook_api.get_connections('me', 'friends')
    
    auths = []
    friends.each do |friend|
      auth = Authorization.where(:provider => 'facebook', :uid => friend['id']).first
      if !auth.nil?
        auths << auth.user
      end
    end
    auths
  end
    
  # Setup the facebook api wrapper.
  def load_facebook_api
    return if !@facebook_api.nil?
    
    # Find the user token
    auth = @user_model.authorizations.where(:provider => 'facebook').first
    if !auth.nil?
      @facebook_api = Koala::Facebook::API.new(auth.token)
    else
      raise 'User does not have a Facebook authorization.'
    end
  end
  
end