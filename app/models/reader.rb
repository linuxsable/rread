class Reader < ActiveRecord::Base
  belongs_to :user
  has_many :blogs
end
