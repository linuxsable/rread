class Authorization < ActiveRecord::Base
  PROVIDER_FACEBOOK = 1
  PROVIDER_TWITTER = 2
  
  belongs_to :user
  
  validates_presence_of :user_id, :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider
  
  def self.find_from_hash(hash)
    find_by_provider_and_uid(hash['provider'], hash['uid'])
  end

  def self.create_from_hash(hash, user = nil)
    user ||= User.create_from_hash!(hash)
    
    create! do |auth|
      auth.user = user
      auth.uid = hash['uid']
      auth.token = hash['credentials']['token']
      auth.provider = hash['provider']
    end
    
    UserMeta.create_from_hash_and_user!(hash, user)
  end
end
