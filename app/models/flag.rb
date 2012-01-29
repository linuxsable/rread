class Flag < ActiveRecord::Base
  belongs_to :user
  belongs_to :target, :polymorphic => true

  # Flag Types
  OTHER           = 1
  SPAM            = 2
  PORN            = 3
  ATTACK_OR_HATE  = 4
  VIOLENCE        = 5

  def self.add(user, flag_type, target)
    return false if user.blank? or flag_type.blank? or target.blank?
    create!(:user => user, :flag_type => flag_type, :target => target)
  end
end
