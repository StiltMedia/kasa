class CreateNegotiations < ActiveRecord::Migration
  def change
    create_table :negotiations do |t|
      t.integer :src
      t.integer :dst
      t.text :details
      t.timestamp :ndate

      t.timestamps null: false
    end
  end
end
