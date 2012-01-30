class CreateArticleStatuses < ActiveRecord::Migration
  def change
    create_table :article_statuses do |t|
      t.integer :user_id, :null => false
      t.integer :article_id, :null => false
      t.integer :like_id
      t.integer :article_read_id
      t.timestamps
    end
  end
end
