class CreateOpenHouseTimes < ActiveRecord::Migration
  def change
    create_table :open_house_times do |t|
      t.timestamp :odate
      t.timestamp :start_time
      t.timestamp :end_time
      t.references :advert, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
