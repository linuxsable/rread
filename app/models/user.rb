class User < ActiveRecord::Base
  has_many :authorizations
  has_many :provider_infos
  has_many :activities
  has_many :likes
  has_many :flags
  has_many :article_statuses
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

    user.setup_reader

    return user
  end

  # Create the user reader if necessary.
  def setup_reader
    if self.reader != nil
      return self.reader
    end

    reader = Reader.create do |reader|
      reader.user = self
    end

    reader.add_all_subscriptions
  end

  def onboard!
    self.onboarded = true
    self.onboarded_at = Time.now
    self.save!
  end

end