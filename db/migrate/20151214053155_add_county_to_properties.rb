class AddCountyToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :county, :string
  end
end
