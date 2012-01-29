# This table handles the read status of an
# article in the system for a given user. If a user
# ever reads an article anywhere, a new record for that
# article will get created here so we know which ones he's read.
class ArticleStatus < ActiveRecord::Base
  belongs_to :article
  belongs_to :user

  validates :article_id, :user_id, :presence => true
  validates :user_id, :uniqueness => { :scope => :article_id }
end