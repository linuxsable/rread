class CreateUserMeta < ActiveRecord::Migration
  def change
    create_table :user_meta do |t|
      t.integer :user_id, :null => false
      t.string :provider, :null => false
      t.string :uid, :null => false
      t.string :username
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :avatar
      t.text :description
      t.string :location

      t.timestamps
    end
  end
end
