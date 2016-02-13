class RemoveOpenHouseBegToProperties < ActiveRecord::Migration
  def change
    remove_column :properties, :open_house_beg, :timestamp
  end
end
