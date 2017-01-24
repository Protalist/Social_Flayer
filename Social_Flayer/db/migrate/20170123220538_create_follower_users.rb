class CreateFollowerUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :follower_users do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
  end
end
