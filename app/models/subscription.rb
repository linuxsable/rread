class Subscription < ActiveRecord::Base
	belongs_to :blog
	belongs_to :reader
end
