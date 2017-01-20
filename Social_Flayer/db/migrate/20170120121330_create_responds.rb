class CreateResponds < ActiveRecord::Migration[5.0]
  def change
    create_table :responds do |t|
      t.belongs_to :store, foreign_key: true
      t.belongs_to :comment, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end
