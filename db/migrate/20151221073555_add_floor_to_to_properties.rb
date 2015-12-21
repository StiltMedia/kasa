class AddFloorToToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :floor, :string
  end
end
