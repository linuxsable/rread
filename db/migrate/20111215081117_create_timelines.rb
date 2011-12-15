class CreateTimelines < ActiveRecord::Migration
  def change
    create_table :timelines do |t|
      t.integer :blog_id
      t.integer :reader_id

      t.timestamps
    end
  end
end
