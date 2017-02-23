class CreateReports < ActiveRecord::Migration[5.0]
  def change
    create_table :reports do |t|
      t.integer :reporter_id
      t.integer :reported_id
      t.text :motivation

      t.timestamps
    end
  end
end
