class SubscriptionObserver < ActiveRecord::Observer
  def after_create(sub)
    Activity.add(sub.reader.user, Activity::SUBSCRIPTION_ADDED, sub)
  end
end