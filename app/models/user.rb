class User < ActiveRecord::Base
  has_many :authorizations
  has_many :provider_infos
  has_many :activities
  has_many :likes
  has_many :flags
  has_many :article_statuses
  has_many :article_reads
  has_one :reader
  
  has_many :friendships
  has_many :friends, :through => :friendships
  
  has_many :inverse_friendships, :class_name => 'Friendship', :foreign_key => 'friend_id'
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user
  
  # Create from the omniauth hash.
  def self.create_from_hash(hash)
    user = create! do |u|
      u.name = hash['info']['name']
      # Set a flag so that they have to finish onboarding
      # before they can continue to use the site logged in.
      u.onboarded = false
      u.greader_imported = false
      u.private_reading = false
    end

    Rails.logger.info(user.inspect)

    user.setup_reader

    return user
  end

  # Create the user reader if necessary.
  def setup_reader
    if self.reader != nil
      return self.reader
    end

    reader = Reader.create! do |reader|
      reader.user = self
    end

    # reader.add_all_subscriptions
  end

  def onboard!
    self.onboarded = true
    self.onboarded_at = Time.now
    self.save!
  end

  def read_article(article)
    # First check if it's read already
    status_query = ArticleStatus.where(:article_id => article.id, :user_id => self.id)
    status = status_query.first

    if status_query.exists?
      return true if status.article_read_id?
    end

    ActiveRecord::Base.transaction {
      # Create the Read record
      article_read = ArticleRead.create!(:user => self, :article => article)

      # Create the ArticleStatus record
      if status_query.exists?
        status.article_read_id = article_read.id
        status.save!
      else
        ArticleStatus.create!(
          :user => self,
          :article => article,
          :article_read_id => article_read.id,
          :blog_id => article.blog_id
        )
      end
    }

    true
  end

  def like_article(article)
    status_query = ArticleStatus.where(:article_id => article.id, :user_id => self.id)
    status = status_query.first

    if status_query.exists?
      return true if status.like_id?
    end

    ActiveRecord::Base.transaction {
      # Create the like record
      like = Like.create!(:user => self, :target => article)

      # Create the ArticleStatus record
      if status_query.exists?
        status.like_id = like.id
        status.save!
      else
        ArticleStatus.create!(
          :user => self,
          :article => article,
          :like_id => like.id,
          :blog_id => article.blog_id
        )
      end
    }

    true
  end
  
  def friend_activity_feed
    friend_ids = []
    friendships.each { |f| friend_ids << f.friend_id }
    ids = friend_ids << self.id
    Activity.where(:user_id => ids).order('created_at DESC').limit(10)
  end

  def avatar
    load_provider_model
    @provider_info_model.avatar
  end

  def full_name
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
    friendships.each do |f|
      output << f.friend
    end
    output
  end

  # Get inverse friends (people who've added this user).
  def inverse_friends
    output = []
    inverse_friendships.each do |f|
      output << f.user
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

  # Are you friends with another user?
  def friend?(user)
    if !user.is_a? User
      raise "'user' must be a User obj"
    end
    
    result = Friendship
      .where(:friend_id => user.id)
      .limit(1)
      .first

    !result.nil?
  end

  # Is the other guy a friend of yours?
  def inverse_friend?(user)
    if !user.is_a? User
      raise "'user' must be a User obj"
    end
    
    result = Friendship
      .where(:user_id => user.id, :friend_id => self.id)
      .first

    !result.nil?
  end

  # Are you friends with another user
  # and are they friends with you?
  def mutual_friend?(user)
    if !user.is_a? User
      raise "'user' must be a User obj"
    end
    
    friend?(user) and inverse_friend?(user)
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
      if !friend?(auth)
        Friendship.create! do |f|
          f.user_id = self.id
          f.friend_id = auth.id
        end
      end
      
      # Create the inverse friendship to save
      # extra db taxes later when the user logs in
      if !inverse_friend?(auth)
        Friendship.create! do |f|
          f.user_id = auth.id
          f.friend_id = self.id
        end
      end
    end
  end

  def async_facebook_friends
    Resque.enqueue(FriendshipSyncer, self.id)
  end

  private

  # This helps to lazy load the provder model only if it's
  # needed by getters of this class.
  #
  # TODO: When we have more providers, this will have to be updated.
  def load_provider_model
    @provider_info_model ||= provider_infos.first
  end

  # Search the users facebook friends to see which ones
  # have internal accounts with us. This is used for the
  # import process.
  def find_facebook_friends_with_accounts
    load_facebook_api
    friends = @facebook_api.get_connections('me', 'friends')
    
    friend_ids = []
    friends.each { |friend| friend_ids << friend['id'] }

    auths = Authorization.where(:provider => 'facebook', :uid => friend_ids)

    output = []
    auths.each { |auth| output << auth.user }

    output
  end

  # Setup the facebook api wrapper.
  def load_facebook_api
    return if !@facebook_api.nil?
    
    # Find the user token
    auth = authorizations.where(:provider => 'facebook').first
    if !auth.nil?
      @facebook_api = Koala::Facebook::API.new(auth.token)
    else
      raise 'User does not have a Facebook authorization.'
    end
  end
end