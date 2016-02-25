class AddHtimeToHits < ActiveRecord::Migration
  def change
    add_column :hits, :htime, :timestamp
  end
end
