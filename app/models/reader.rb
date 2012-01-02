class Reader < ActiveRecord::Base
  belongs_to :user
  has_many :subscriptions
  has_many :blogs, :through => :subscriptions

  validates_uniqueness_of :user_id

  # This will handle high level adding of a Subscription.
  # It will take a feed-url and see if a blog exists for that URL.
  # If a blog doesn't exist it will create the blog.
  # It will then add a link to that blog (a Subscription record).
  # It will sync the articles for the blog in the current thread
  # and wont throw them on the queue (don't want the user to be able
  # to see the blog without articles in the UI). Hopefully this won't
  # happen too much after the beginning of the app (at least it wont happen)
  # on popular blogs.
  def add_subscription(feed_url)
    blog = Blog.find_by_feed_url(feed_url)
    if blog.nil?
      blog = Blog.create_from_user_and_feed_url(self.user, feed_url)  
    end
    subscriptions.build(:blog => blog).save
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

  def article_feed
    blog_ids = []
    self.blogs.each { |b| blog_ids << b.id }
    Article.where(:blog_id => blog_ids).order('published_at DESC').limit(30)
  end
end