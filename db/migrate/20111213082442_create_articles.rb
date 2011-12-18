class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.integer :blog_id
      t.string :title
      t.string :author
      t.text :content
      t.string :entry_id
      t.timestamp :published_date

      t.timestamps
    end
  end
end
