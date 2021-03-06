class Article < ActiveRecord::Base
  has_many :article_statuses
  belongs_to :blog

  validates_presence_of :title, :published_at, :url
  # validates_uniqueness_of :content, :scope => :blog_id
  validates_uniqueness_of :published_at, :scope => :blog_id
  validates_uniqueness_of :url, :scope => :blog_id

  validates :url, :format => {
    :with => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix,
    :message => "Must be a valid URL."
  }

  def self.title_by_id(id)
    Rails.cache.fetch("article_title|#{id}", :expires_in => 5.hours) {
      article = find(id)
      if !article.nil?
        article.title
      end
    }
  end
end