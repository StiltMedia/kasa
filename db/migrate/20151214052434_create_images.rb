class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :guid
      t.integer :serial
      t.references :property, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
