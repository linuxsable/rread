class LikeObserver < ActiveRecord::Observer
  def after_create(like)
    activity_type = nil

    case like.target_type
    when 'Article'
      activity_type = Activity::ARTICLE_LIKED
    when 'Blog'
      activity_type = Activity::BLOG_LIKED
    else
      raise 'Need an activity type for this like.'
    end

    Activity.add(like.user, activity_type, like)
  end
end