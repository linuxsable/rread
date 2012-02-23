class Reader < ActiveRecord::Base
  include ActionView::Helpers::TextHelper

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
      begin
        blog = Blog.create_from_user_and_feed_url(self.user, feed_url)  
      rescue Exception => e
        return false
      end
    end

    begin
      return Subscription.create!(:reader => self, :blog => blog)  
    rescue Exception => e
      Rails.logger.error e
    end

    true
  end

  def remove_subscription(feed_url)
    blog = Blog.find_by_feed_url(feed_url)
    return false if blog.nil?

    sub = subscriptions.where(:blog_id => blog.id).limit(1).first
    return false if sub.nil?
    sub.delete
  end

  def add_all_subscriptions
    Blog.all.each { |blog|
      subscriptions.build(:blog => blog).save!
    }
  end

  # Will import all the Google Reader feeds
  # of the authing user to the current reader.
  def import_greader(email, password)
    creds = { :email => email, :password => password }
    
    greader = GReader.auth(creds)
    greader.feeds.each do |feed|
      add_subscription(feed.url)
    end
  end

  def article_feed(count=nil, blog_filter_id=nil, timestamp_since=nil)
    blog_ids = []

    if blog_filter_id.nil?
      blogs.each { |b| blog_ids << b.id }
    else
      blog_ids << blog_filter_id
    end

    return {} if blog_ids.empty?

    if !timestamp_since.nil?
      if !timestamp_since.is_a? Time
        timestamp_since = Time.at(timestamp_since.to_i / 1000)
      end

      articles = Article.where(:blog_id => blog_ids)
        .where("created_at >= DATETIME(?)", timestamp_since)
        .order('published_at DESC')
        .limit(count)
    else
      articles = Article.where(:blog_id => blog_ids).order('published_at DESC').limit(count)
    end
    
    return {} if articles.empty?

    articles_by_id = {}
    articles.each do |article|
      articles_by_id[article.id] = {
        'id' => article.id,
        'blog_id' => article.blog_id,
        'blog_name' => Blog.get_name_by_id(article.blog_id),
        'blog_url' => Blog.get_url_by_id(article.blog_id),
        'title' => article.title,
        'blurb' => truncate(strip_tags(article.content), :length => 120, :separator => ' '),
        'content' => article.content,
        'created_at' => article.created_at,
        'published_at' => article.published_at,
        'url' => article.url,
        'read' => false,
        'liked' => false
      }
    end

    article_statuses = ArticleStatus.where(:user_id => user.id, :article_id => articles_by_id.keys)

    # Return the articles if there are no article status rows
    return articles_by_id.values if article_statuses.empty?

    # Bring in the article status meta data into the articles array
    article_statuses.each do |article_status|
      article_id = article_status.article_id

      if articles_by_id.has_key?(article_id)
        if article_status.article_read_id?
          articles_by_id[article_id]['read'] = true
        end

        if article_status.like_id?
          articles_by_id[article_id]['liked'] = true
        end
      end
    end

    articles_by_id.values
  end

  def subscription_list(alpha_sort=true)
    # TODO: Kill this cache when adding or deleteing subscriptions
    # Rails.cache.fetch("subscription_list|#{user.id}", :expires_in => 5.hours) {
      output = []
      subs = subscriptions.select(:blog_id)

      subs.each { |sub| 
        output << {
          :blog_id => sub.blog_id,
          :blog_name => Blog.get_name_by_id(sub.blog_id)
        }
      }

      if alpha_sort
        output.sort! { |a, b| a[:blog_name] <=> b[:blog_name] }
      end

      output
    # }
  end

  def async_all_subscriptions
    blogs.each { |b| b.async_articles }
  end
end