class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :user_id, :null => false
      t.integer :target_id, :null => false
      t.string :target_type, :null => false

      t.timestamps
    end

    add_index :likes, [:target_id, :target_type]
    add_index :likes, :user_id
  end
end
