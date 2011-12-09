# High level user of our system.
# This will hold all high level methods
# and talk directly to models.
class AppUser
  def initialize(user_id)
    user_record = User.find(user_id)
    
    if user_record.nil?
      raise "'user_id' not found in system"
    end
    
    @user_model = user_record
    
    init_facebook_api
  end
  
  def find_facebook_friends_with_accounts
    friends = @facebook_api.get_connections('me', 'friends')
    friends.each do |friend|
      Rails.Logger.debug friend
      Authorization.where(:provider => 'facebook', :uid => friend.user_id).empty?
    end
  end
  
  private 
  
  def init_facebook_api
    # Find the user token
    auth = @user_model.authorizations.where(:provider => 'facebook').first
    if !auth.nil?
      @facebook_api = Koala::Facebook::API.new(auth.token)
    else
      raise 'User does not have a Facebook authorization.'
    end
  end
  
end