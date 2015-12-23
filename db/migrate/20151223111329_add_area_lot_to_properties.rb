class AddAreaLotToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :area_lot, :integer
  end
end
