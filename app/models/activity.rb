class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :target, :polymorphic => true

  # Activity Types
  ARTICLE_LIKED       = 1
  ARTICLE_READ        = 2
  SUBSCRIPTION_ADDED  = 3
  FRIENDSHIP_ADDED    = 4
  BLOG_LIKED          = 5

  def self.batch_add(users, activity_type, target)
    return false if users.blank? or activity_type.blank? or target.blank?
    inserts = []
    users.each {|user| inserts.push "('#{user.id}', '#{activity_type}', '#{target.id}', '#{target.class}', UTC_TIMESTAMP())" }

    sql = "INSERT INTO activities (`user_id`, `activity_type`, `target_id`, `target_type`, `created_at`) VALUES #{inserts.join(", ")}"
    ActiveRecord::Base.connection.execute sql
  end

  def self.add(user, activity_type, target)
    return false if user.blank? or activity_type.blank? or target.blank?
    create!(:user => user, :activity_type => activity_type, :target => target)
  end

  # This is how you actually get the feed for the
  # logged in user for example. If Brian Fantana wants
  # to see his friend stream, you would run this passing
  # Brian Fantana user object.
  def self.feed_for_user(user)
    if !user.is_a? User
      raise 'user must be of "User" type'
    end

    friend_ids = []
    user.friendships.each { |f| friend_ids << f.friend_id }
    where(:user_id => friend_ids)
  end
end
