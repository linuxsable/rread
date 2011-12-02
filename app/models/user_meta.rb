class UserMeta < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :user_id, :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider
  
  def self.create_from_hash_and_user!(hash, user)
    create! do |m|
      m.user = user
      m.uid = hash['uid']
      m.provider = hash['provider']
      m.username = hash['info']['nickname']
      m.email = hash['info']['email']
      m.first_name = hash['info']['first_name']
      m.last_name = hash['info']['last_name']
      m.avatar = hash['info']['image']
      m.description = hash['info']['description']
      m.location = hash['info']['location']
    end
  end
  
end
