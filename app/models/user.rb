class User < ActiveRecord::Base
  has_many :authorizations
  has_many :user_metas
  
  def self.create_from_hash!(hash)
    create! do |user|
      user.name = hash['info']['name']
    end
  end
end
