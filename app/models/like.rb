class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :target, :polymorphic => true
  belongs_to :article_status

  def self.add(user, target)
    return false if user.blank? or target.blank?
    create!(:user => user, :target => target)
  end
end
