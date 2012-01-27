class CreateReadStatuses < ActiveRecord::Migration
  def change
    create_table :read_statuses do |t|
      t.integer :user_id
      t.integer :article_id

      t.timestamps
    end
  end
end
