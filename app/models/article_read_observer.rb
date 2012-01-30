class ArticleReadObserver < ActiveRecord::Observer
  def after_create(article_read)
    Activity.add(article_read.user, Activity::ARTICLE_READ, article_read)    
  end
end
