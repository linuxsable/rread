class User < ActiveRecord::Base
  has_many :authorizations
  has_many :provider_infos
  
  # Create from the omniauth hash
  def self.create_from_hash(hash)
    create! do |u|
      u.name = hash['info']['name']
    end
  end
  
end
