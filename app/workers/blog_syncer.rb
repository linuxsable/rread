class BlogSyncer
  @queue = :blog_syncer

  def self.perform(blog_id)
    blog = Blog.find(blog_id)
    return if blog.articles_synced?
    blog.sync_articles
  end
end