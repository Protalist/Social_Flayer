class CreatePhotoStores < ActiveRecord::Migration[5.0]
  def change
    create_table :photo_stores do |t|
      t.belongs_to :store, foreign_key: true
      t.string :image

      t.timestamps
    end
  end
end
