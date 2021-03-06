# 1 worker = 3 blogs per second
#
# 1 minutes = 180 blogs
# 2 minutes = 360 blogs
#
# 1 worker on 1000 blogs = 6 minutes
# 2 workers on 1000 blogs = 3 minutes
class Blog < ActiveRecord::Base
  has_many :articles
  has_many :subscriptions
  has_many :readers, :through => :subscriptions

  validates_presence_of :url, :feed_url, :name, :first_created_by
  validates_uniqueness_of :url, :feed_url, :name

  validates :url, :feed_url, :format => {
    :with => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix,
    :message => "Must be a valid URL."
  }

  # Save some bandwith
  SYNC_DIFFERENCE = 10.minutes

  # Look-up a feed_url and create the new blog record.
  # Use feedzira to do this.
  def self.create_from_feed_url(user, feed_url)
    rss_log = Logger.new('log/rss.log')
    feed = Feedzirra::Feed.fetch_and_parse(feed_url)

    if feed.nil? or feed == 404
      msg = "Cannot fetch and parse #{feed_url}"
      rss_log.debug(msg)
      raise msg
    end

    blog = self.new do |b|
      b.url = feed.url
      b.feed_url = feed.feed_url
      b.name = feed.title
      b.description = nil
      b.avatar = nil
      b.first_created_by = user.id      
    end

    if blog.save
      blog.async_articles
    end

    return blog
  end

  def self.sync_articles_all
    all.each { |b|
      begin
        b.sync_articles
      rescue Exception => e
        p e
      end
    }
  end

  def self.get_name_by_id(blog_id)
    Rails.cache.fetch("blog_name|#{blog_id}", :expires_in => 5.hours) {
      blog = find(blog_id)
      if !blog.nil?
        blog.name
      end
    }
  end

  def self.get_url_by_id(blog_id) 
    Rails.cache.fetch("blog_url|#{blog_id}", :expires_in => 5.hours) {
      blog = find(blog_id)
      if !blog.nil?
        blog.url
      end
    }
  end

  # Check if the blog has had it's articles sync'd in
  # a certain period below SYNC_DIFFERENCE
  #
  # NEEDS UNIT TEST
  def articles_synced?
    Time.now.to_i - articles_last_syncd_at.to_i <= SYNC_DIFFERENCE
  end

  # Hit the blog and parse and update the articles
  # in the db.
  #
  # NEEDS UNIT TEST
  def sync_articles(feed=nil)
    rss_log = Logger.new('log/rss.log')

    if feed.nil?
      feed = Feedzirra::Feed.fetch_and_parse(feed_url)
      if feed.nil?
        raise 'Cannot sync articles'
      end
    end

    return false if feed.nil? or feed.entries.empty?

    feed.entries.each do |entry|
      if entry.published.to_i > self.articles_last_syncd_at.to_i

        content = nil
        if entry.content.nil?
          content = entry.summary
        else
          content = entry.content
        end

        rss_log.debug(entry) if content.nil?

        begin
          entry.sanitize!
          Article.create! do |a|
            a.blog = self
            a.title = entry.title
            a.author = entry.author
            a.url = entry.url
            a.content = content
            a.published_at = entry.published
          end
        rescue Exception => e
          puts e.message
        end
      end
    end

    self.articles_last_syncd_at = Time.now
    self.save!
  end

  def async_articles
    Resque.enqueue(BlogSyncer, self.id)
  end

end
