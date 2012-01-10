class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :target, :polymorphic => true

  default_scope :order => 'activities.created_at DESC', :limit => 15

  # Activity Types
  ARTICLE_LIKED = 1
  SUBSCRIPTION_ADDED = 2

  class << self
    def batch_add(users, activity_type, target)
      return false if users.blank? or activity_type.blank? or target.blank?
      inserts = []
      users.each {|user| inserts.push "('#{user.id}', '#{activity_type}', '#{target.id}', '#{target.class}', UTC_TIMESTAMP())" }

      sql = "INSERT INTO activities (`user_id`, `activity_type`, `target_id`, `target_type`, `created_at`) VALUES #{inserts.join(", ")}"
      ActiveRecord::Base.connection.execute sql
    end

    def add(user, activity_type, target)
      return false if user.blank? or activity_type.blank? or target.blank?
      activity = Activity.new(:user => user, :activity_type => activity_type, :target => target)
      activity.save!
    end
  end
  
end