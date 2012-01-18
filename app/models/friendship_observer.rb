class FriendshipObserver < ActiveRecord::Observer
  def after_create(friendship)
    Activity.add(friendship.user, Activity::FRIENDSHIP_ADDED, friendship)    
  end
end
