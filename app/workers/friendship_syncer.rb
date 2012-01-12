class FriendshipSyncer
  @queue = :friendship_syncer

  def self.perform(user_id)
    user = AppUser.get_by_user_id(user_id)
    user.sync_facebook_friends
  end
end