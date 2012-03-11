class AddUnreadCountMarker < ActiveRecord::Migration
  def up
    add_column :subscriptions, :unread_marker, :datetime
  end

  def down
    remove_column :subscriptions, :unread_marker
  end
end
