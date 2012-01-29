class CreateFlags < ActiveRecord::Migration
  def change
    create_table :flags do |t|
      t.integer :user_id, :null => false
      t.integer :flag_type, :null => false
      t.integer :target_id, :null => false
      t.string :target_type, :null => false

      t.timestamps
    end

    add_index :flags, [:target_id, :target_type]
    add_index :flags, :user_id
  end
end
