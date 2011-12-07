class Authorization < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :user_id, :uid, :provider, :token, :secret
  validates_uniqueness_of :provider
  
  # Find from the omniauth hash
  def self.find_from_hash(hash)
    find_by_provider_and_uid(hash['provider'], hash['uid'])
  end

  # Create from the omniauth hash
  def self.create_from_hash(hash, user = nil)
    user ||= User.create_from_hash(hash)
    
    create! do |a|
      a.user     = user
      a.uid      = hash['uid']
      a.token    = hash['credentials']['token']
      a.secret   = hash['credentials']['secret']
      a.provider = hash['provider']
    end
    
    ProviderInfo.create_from_hash_and_user(hash, user)
  end
end
