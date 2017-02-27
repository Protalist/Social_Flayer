class CreateStores < ActiveRecord::Migration[5.0]
  def change
    create_table :stores do |t|
      t.string :name
      t.string :location
      t.string :image
      t.integer :owner_id
      t.string :owner_type
      t.timestamps
    end

    add_index :stores, [:owner_type, :owner_id]
  end
end
