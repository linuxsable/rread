class AddBlogIdToArticleStatuses < ActiveRecord::Migration
  def up
    add_column :article_statuses, :blog_id, :integer
  end

  def down
    remove_column :article_statuses, :blog_id
  end
end
