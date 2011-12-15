class Reader < ActiveRecord::Base
  belongs_to :user
  has_many :timelines
  has_many :blogs, :through => :timelines
end
