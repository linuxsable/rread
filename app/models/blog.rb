class Blog < ActiveRecord::Base
  has_many :articles
  has_many :subscriptions
  has_many :readers, :through => :subscriptions

  SYNC_DIFFERENCE = 30.seconds

  # Really need to setup validations

  # Check if the blog has had it's articles sync'd in
  # a certain period below SYNC_DIFFERENCE
  def articles_synced?
    Time.now.to_i - articles_last_syncd_at.to_i <= SYNC_DIFFERENCE
  end

  # Hit the blog and parse and update the articles
  # in the db.
  def sync_articles
    feed = Feedzirra::Feed.fetch_and_parse(feed_url)

    feed.entries.each do |entry|
      if entry.published.to_i > self.articles_last_syncd_at.to_i
        entry.sanitize!

        Article.create do |a|
          a.blog = self
          a.title = entry.title
          a.author = entry.author
          a.url = entry.url
          a.content = entry.content
          a.published_at = entry.published
        end
      end
    end

    self.articles_last_syncd_at = Time.now
    self.save
  end

  def sync_articles_delayed
    sync_articles
  end

  # Not sure if this is the best method   
  handle_asynchronously :sync_articles_delayed, :priority => Proc.new { |i| i.readers.count }

end