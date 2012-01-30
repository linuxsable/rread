class CreateArticleReads < ActiveRecord::Migration
  def change
    create_table :article_reads do |t|
      t.integer :user_id, :null => false
      t.integer :article_id, :null => false

      t.timestamps
    end
  end
end
