class ArticleRead < ActiveRecord::Base
  belongs_to :article
  belongs_to :user
  belongs_to :article_status
end
