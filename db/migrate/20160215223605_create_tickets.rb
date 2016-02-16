class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :state
      t.string :subject

      t.timestamps null: false
    end
  end
end
