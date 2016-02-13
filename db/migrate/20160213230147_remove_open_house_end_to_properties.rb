class RemoveOpenHouseEndToProperties < ActiveRecord::Migration
  def change
    remove_column :properties, :open_house_end, :timestamp
  end
end
