class CreateArticleStatuses < ActiveRecord::Migration
  def change
    create_table :article_statuses do |t|
      t.integer :user_id
      t.integer :article_id
      t.integer :read
      t.integer :hearted
      t.integer :starred
      t.timestamps
    end
  end
end
