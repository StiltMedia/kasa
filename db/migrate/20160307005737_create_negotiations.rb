class CreateNegotiations < ActiveRecord::Migration
  def change
    create_table :negotiations do |t|
      t.integer :buyer_id
      t.integer :seller_id
      t.string :ntype
      t.integer :amount
      t.integer :property_id
      t.timestamp :ndate

      t.timestamps null: false
    end
  end
end
