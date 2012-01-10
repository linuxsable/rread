class Subscription < ActiveRecord::Base
	belongs_to :blog
	belongs_to :reader
  
  # Don't allow adding the same blog to the reader.
  validates_uniqueness_of :blog_id, :scope => :reader_id
	validates_presence_of :blog_id, :reader_id
end
