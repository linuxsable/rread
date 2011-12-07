class CreateProviderInfos < ActiveRecord::Migration
  def change
    create_table :provider_infos do |t|
      t.integer :user_id
      t.string :provider
      t.string :uid
      t.string :username
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :avatar
      t.text :description
      t.string :location

      t.timestamps
    end
  end
end
