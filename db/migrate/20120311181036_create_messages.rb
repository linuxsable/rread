class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :user_id, :null => false
      t.integer :recipient_user_id, :null => false
      t.text :body
      t.integer :attachment_id, :null => false
      t.string :attachment_type, :null => false
      t.boolean :read, :null => false, :default => false
      t.timestamps
    end

    add_index :messages, [:attachment_id, :attachment_type]
    add_index :messages, :user_id
  end
end
