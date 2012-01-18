class Article < ActiveRecord::Base
  belongs_to :blog

  validates_presence_of :title, :published_at, :url
  # validates_uniqueness_of :content, :scope => :blog_id
  validates_uniqueness_of :published_at, :scope => :blog_id
  validates_uniqueness_of :url, :scope => :blog_id

  validates :url, :format => {
    :with => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix,
    :message => "Must be a valid URL."
  }

  # Mostly used for debugging so you can see text output
  def self.text_list
    output = []
    Article.all.each { |a| output << a.blog.name + ' -- ' + a.title }
    output
  end
end