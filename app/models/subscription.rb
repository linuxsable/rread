class Subscription < ActiveRecord::Base
	belongs_to :blog
	belongs_to :reader
  
  # Don't allow adding the same blog to the reader.
  validates :blog_id, :uniqueness => {
    :scope => :reader_id,
    :message => "Already subscribed to blog"
  }
  validates :blog_id, :presence => true
  validates :reader_id, :presence => true

  def self.create_with_unread_marker!(reader, blog)
    Subscription.create!(:reader => reader, :blog => blog, :unread_marker => Time.now)
  end
end