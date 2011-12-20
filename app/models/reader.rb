class Reader < ActiveRecord::Base
  belongs_to :user
  has_many :subscriptions
  has_many :blogs, :through => :subscriptions
end
