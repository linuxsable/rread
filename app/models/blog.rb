class Blog < ActiveRecord::Base
  has_many :articles
  has_many :timelines
  has_many :readers, :through => :timelines

  # Really need to setup validations

  def self.articles_synced?
  	# Check if the blog has had it's articles sync'd in
  	# a certain period below 1 minute
  end

  def sync_articles
  	# Hit the blog and parse and update the articles
  	# in the db.
  end

end
