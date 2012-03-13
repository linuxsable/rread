class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :target, :polymorphic => true
  belongs_to :article_status
end
