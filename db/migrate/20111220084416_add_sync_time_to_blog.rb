class AddSyncTimeToBlog < ActiveRecord::Migration
  def change
    add_column :blogs, :articles_last_syncd_at, :datetime
  end
end
