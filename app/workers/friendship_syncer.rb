class FriendshipSyncer
  @queue = :friendship_syncer

  def self.perform(user_id)
    user = User.find_by_id(user_id)
    user.sync_facebook_friends
  end
end