class Reader < ActiveRecord::Base
  include ActionView::Helpers::TextHelper

  belongs_to :user
  has_many :subscriptions
  has_many :blogs, :through => :subscriptions

  validates_uniqueness_of :user_id

  MAX_SUBSCRIPTION_COUNT = 25

  # This should support smart detection
  # of the paramter type. It should be able to add a subscription
  # based on feed_url, regular url, name, etc.
  def add_subscription(feed_url)
    if subscriptions.count >= MAX_SUBSCRIPTION_COUNT
      raise Exception, 'Max amount of user subscriptions'
    end

    blog = Blog.find_by_feed_url(feed_url)
    if blog.nil?
      begin
        blog = Blog.create_from_feed_url(user, feed_url)  
      rescue Exception => e
        Rails.logger.error e
        return false
      end
    end

    Subscription.create_with_unread_marker!(self, blog)
  end

  def remove_subscription(feed_url)
    blog = Blog.find_by_feed_url(feed_url)
    return false if blog.nil?

    sub = subscriptions.where(:blog_id => blog.id).limit(1).first
    return false if sub.nil?
    sub.delete
  end

  def add_all_subscriptions
    Blog.all.each do |blog|
      add_subscription(blog.feed_url)
    end
  end

  # Will import all the Google Reader feeds
  # of the authing user to the current reader.
  def import_greader(email, password)
    errors = []
    creds = { :email => email, :password => password }

    if creds[:email].nil? or creds[:password].nil?
      return false
    end

    greader = GReader.auth(creds)
    greader.feeds.each do |feed|
      begin
        result = add_subscription(feed.url)
        errors << feed.url + ' failed to subscribe' if !result
      rescue Exception => e
        errors << e.message
      end
    end

    return errors if not errors.empty?

    true
  end

  # This is the main method to pull the article feed
  # in the reader (the main page).
  #
  # TODO: If an article is read because it of the
  # unread marker, don't hit the DB asking for the article_status
  # on that item because we already know that it is read (we don't need it).
  def article_feed(count=25, blog_filter_id=nil, timestamp_since=nil)
    subs = []

    if blog_filter_id.nil?
      subs = subscriptions
    else
      subs << subscription.where(:blog_id => blog_filter_id).limit(1)
    end

    return {} if subs.empty?

    blog_ids = []
    subs.each { |b| blog_ids << b.blog_id }

    if !timestamp_since.nil?
      if !timestamp_since.is_a? Time
        timestamp_since = Time.at(timestamp_since.to_i / 1000)
      end

      articles = Article
        .where(:blog_id => blog_ids)
        .where("created_at > ?", timestamp_since)
        .order('published_at DESC')
        .limit(count)
    else
      articles = Article
        .where(:blog_id => blog_ids)
        .order('published_at DESC')
        .limit(count)
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
        # 'blurb' => truncate(strip_tags(article.content), :length => 120, :separator => ' '),
        'content' => article.content,
        # 'created_at' => article.created_at,
        'published_at' => article.published_at,
        'url' => article.url,
        'read' => false,
        'liked' => false
      }

      # Let's check the read status against
      # a mark_all_as_read marker if it exists.
      subs_search = subs.select { |s| s.blog_id == article.blog_id }
      if subs_search.size == 1
        if !subs_search.first.unread_marker.nil?
          if subs_search.first.unread_marker > article.created_at
            articles_by_id[article.id]['read'] = true
          end
        end
      end
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
      subs = subscriptions.select('blog_id, unread_marker')

      subs.each do |sub|
        output << {
          :blog_id => sub.blog_id,
          :blog_name => Blog.get_name_by_id(sub.blog_id),
          :unread_count => unread_count(sub.blog_id)
        }
      end

      if alpha_sort
        output.sort! { |a, b| a[:blog_name] <=> b[:blog_name] }
      end

      output
    # }
  end

  # This will return the unread count for all
  # the subscriptions at once if no blog_id is given.
  def unread_count(blog_id=nil)
    total_count = 0

    if blog_id.nil?
      subs = subscriptions.select('blog_id, unread_marker')
    else
      subs = subscriptions
        .where(:blog_id => blog_id)
        .select('blog_id, unread_marker')
    end

    subs.each do |sub|
      # Now we have to merge in the article_read table to deduct
      # from the total just from the marker.
      status_count = ArticleStatus
        .count(:conditions => ['blog_id = ? and user_id = ? and created_at > ? and article_read_id IS NOT NULL', sub.blog_id, self.user_id, sub.unread_marker])
      total_count -= status_count

      total_count += Article.count(:conditions => ['blog_id = ? and created_at > ?', sub.blog_id, sub.unread_marker])
    end

    if total_count < 0
      Rails.logger.error 'Uread count less than 0'
    end

    total_count
  end

  # This will mark every article as read in the 
  # reader for a specific user.
  #
  # If a blog_id is passed, it will only
  # mark all as read for that blog.
  def mark_all_as_read(blog_id=nil)
    timestamp = Time.now

    subs = []
    if !blog_id.nil?
      subs = subscriptions.where(:blog_id => blog_id).limit(1)
    else
      subs = subscriptions
    end

    subs.each do |sub|
      sub.unread_marker = timestamp

      begin
        sub.save!
      rescue Exception => e
        Rails.logger.error e
        return false
      end
    end

    true
  end

  def async_all_subscriptions
    blogs.each { |b| b.async_articles }
  end
end