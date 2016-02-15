class CreateHits < ActiveRecord::Migration
  def change
    create_table :hits do |t|
      t.string :kind
      t.integer :property_id

      t.timestamps null: false
    end
  end
end
