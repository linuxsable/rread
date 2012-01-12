class BlogSyncer
  @queue = :blog_syncer

  def self.perform(blog_id)
    blog = Blog.find(blog_id)
    blog.sync_articles
  end
end