# This table handles the read status of an
# article in the system for a given user. If a user
# ever reads an article anywhere, a new record for that
# article will get created here so we know which ones he's read.
class ArticleStatus < ActiveRecord::Base
  belongs_to :article
  belongs_to :user
  belongs_to :blog

  validates :article_id, :user_id, :presence => true
  validates :user_id, :uniqueness => { :scope => :article_id }

  def self.read_by_user?(article_id, user)
    where("article_read_id IS NOT NULL").where(:article_id => article_id, :user_id => user.id)
      .limit(1).exists?
  end

  def self.liked_by_user?(article_id, user)
    where("like_id IS NOT NULL").where(:article_id => article_id, :user_id => user.id)
      .limit(1).exists?
  end
end