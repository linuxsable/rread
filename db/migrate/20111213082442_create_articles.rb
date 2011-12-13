class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.integer :blog_id
      t.string :title
      t.text :description
      t.timestamp :publish_date
      t.string :guid

      t.timestamps
    end
  end
end
