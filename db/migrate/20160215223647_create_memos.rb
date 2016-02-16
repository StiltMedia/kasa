class CreateMemos < ActiveRecord::Migration
  def change
    create_table :memos do |t|
      t.string :from
      t.string :to
      t.string :body
      t.references :ticket, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
