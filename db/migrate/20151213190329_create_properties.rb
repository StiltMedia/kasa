class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :full_address

      t.timestamps null: false
    end
  end
end
