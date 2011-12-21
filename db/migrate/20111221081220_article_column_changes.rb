class ArticleColumnChanges < ActiveRecord::Migration
  def up
  	remove_column :articles, :published_date
  	add_column :articles, :published_at, :datetime
  	remove_column :articles, :entry_id
  	add_column :articles, :url, :string
  end

  def down
  	add_column :articles, :published_date
  	remove_column :articles, :published_at
  	add_column :articles, :entry_id, :string
  	remove_colum :articles, :url
  end
end
