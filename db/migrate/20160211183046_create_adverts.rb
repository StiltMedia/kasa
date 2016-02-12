class CreateAdverts < ActiveRecord::Migration
  def change
    create_table :adverts do |t|
      t.references :user, index: true, foreign_key: true
      t.references :property, index: true, foreign_key: true
      t.boolean :seed

      t.timestamps null: false
    end
  end
end
