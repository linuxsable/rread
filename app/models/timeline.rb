class Timeline < ActiveRecord::Base
  belongs_to :blog
  belongs_to :reader
end
