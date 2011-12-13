class Blog < ActiveRecord::Base
  belongs_to :reader
  has_many :articles
end
