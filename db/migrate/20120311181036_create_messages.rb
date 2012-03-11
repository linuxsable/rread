class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :user_id, :null => false
      t.integer :recipient_user_id, :null => false
      t.text :body
      t.integer :article_id
      t.timestamps
    end
  end
end
