class AddOnboardedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :onboarded, :integer
    add_column :users, :onboarded_at, :datetime
    add_column :users, :greader_imported, :integer
    add_column :users, :greader_imported_at, :datetime
    add_column :users, :private_reading, :integer
  end
end
