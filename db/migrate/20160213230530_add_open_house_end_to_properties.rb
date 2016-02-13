class AddOpenHouseEndToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :open_house_end, :string
  end
end
