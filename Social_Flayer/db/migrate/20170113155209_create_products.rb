class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :name
      t.float :price
      t.string :image
      t.integer :duration_h
      t.string :type_p
      t.text :feature
      t.belongs_to :store

      t.timestamps
    end
  end
end
