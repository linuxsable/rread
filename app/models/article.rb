class Article < ActiveRecord::Base
  belongs_to :blog

  validates_presence_of :title, :content, :published_at, :url
  validates_uniqueness_of :content, :published_at, :url

  validates :url, :format => {
    :with => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix,
    :message => "Must be a valid URL."
  }
end