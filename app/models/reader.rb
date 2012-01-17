class Reader < ActiveRecord::Base
  belongs_to :user
  has_many :subscriptions
  has_many :blogs, :through => :subscriptions

  validates_uniqueness_of :user_id

  # This should support smart detection
  # of the paramter type. It should be able to add a subscription
  # based on feed_url, regular url, name, etc.
  def add_subscription(feed_url)
    blog = Blog.find_by_feed_url(feed_url)
    if blog.nil?
      blog = Blog.create_from_user_and_feed_url(self.user, feed_url)  
    end
    subscriptions.build(:blog => blog).save!
  end

  def remove_subscription(feed_url)
    blog = Blog.find_by_feed_url(feed_url)
    return false if blog.nil?

    subscriptions.where(:blog_id => blog.id).limit(1).first.delete!
  end

  def add_all_subscriptions
    Blog.all.each { |blog|
      subscriptions.build(:blog => blog).save!
    }
  end

  # Will import all the Google Reader feeds
  # of the authing user to the current reader.
  def import_greader_feeds(email, password)
    creds = { :email => email, :password => password }
    
    greader = GReader.auth(creds)
    greader.feeds.each do |feed|
      add_subscription(feed.url)
    end
  end

  def article_feed(count=50, blog_filter_id)
    blog_ids = []

    if blog_filter_id.nil?
      self.blogs.each { |b| blog_ids << b.id }
    else
      blog_ids << blog_filter_id
    end
    
    Article.where(:blog_id => blog_ids).order('published_at DESC').limit(count)
  end

  def async_all_subscriptions
    self.blogs.each { |b|
      b.async_articles
    }
  end
end