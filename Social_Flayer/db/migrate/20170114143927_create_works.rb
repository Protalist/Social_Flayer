class CreateWorks < ActiveRecord::Migration[5.0]
  def change
    create_table :works do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :store, foreign_key: true
      t.boolean :accept
      t.timestamps
    end
  end
end
