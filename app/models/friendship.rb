class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => 'User'

  def self.friend_id_by_id(id)
    Rails.cache.fetch("friendship_friend_id|#{id}", :expires_in => 5.hours) {
      friendship = find(id)
      if !friendship.nil?
        friendship.friend_id
      end
    }
  end
end
