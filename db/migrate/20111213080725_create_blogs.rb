class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.integer :reader_id
      t.string :url
      t.string :feed_url
      t.string :name
      t.text :description
      t.integer :first_created_by
      t.string :avatar

      t.timestamps
    end
  end
end
