class Blog < ActiveRecord::Base
  has_many :articles
  has_many :timelines
  has_many :readers, :through => :timelines
end
