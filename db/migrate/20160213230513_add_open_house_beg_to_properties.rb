class AddOpenHouseBegToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :open_house_beg, :string
  end
end
