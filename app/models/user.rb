class User < ActiveRecord::Base
  has_many :authorizations
  has_many :provider_infos
  
  has_many :friendships
  has_many :friends, :through => :friendships
  
  has_many :inverse_friendships, :class_name => 'Friendship', :foreign_key => 'friend_id'
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user
  
  # Create from the omniauth hash
  def self.create_from_hash(hash)
    create! do |u|
      u.name = hash['info']['name']
    end
  end
    
end
