class Blog < ActiveRecord::Base
  has_many :articles
  has_many :subscriptions
  has_many :readers, :through => :subscriptions

  SYNC_DIFFERENCE = 15.seconds

  # Really need to setup validations

  def articles_synced?
  	# Check if the blog has had it's articles sync'd in
  	# a certain period below 1 minute
    self.where()
  end

  def sync_articles
  	# Hit the blog and parse and update the articles
  	# in the db.
  end

end
