class Activity < ActiveRecord::Base
  attr_accessor :user_name, :user_avatar, :target_name

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

  # This appends the user_name to the result set. This field
  # is not actually stored in the DB.
  def self.feed(ids, count=20)
    result = self.where(:user_id => ids)
      .where("activity_type != ?", ARTICLE_READ)
      .order('created_at DESC')
      .limit(count)

    return result if result.empty?

    result.each do |item|
      # Append the user_name
      user = User.find(item.user_id)
      item.user_name = user.name
      item.user_avatar = user.avatar

      # Append the target name based on the target
      # if item.activity_type == ARTICLE_READ
      #   item.target_name = Article.title_by_id(item.target_id)
      if item.activity_type == SUBSCRIPTION_ADDED
        blog_id = Subscription.blog_id_by_id(item.target_id)
        item.target_name = Blog.get_name_by_id(blog_id)
      elsif item.activity_type == FRIENDSHIP_ADDED
        friend_id = Friendship.friend_id_by_id(item.target_id)
        item.target_name = User.name_by_id(friend_id)
      end
    end
  end
end
