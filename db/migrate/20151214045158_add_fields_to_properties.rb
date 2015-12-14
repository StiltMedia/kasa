class AddFieldsToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :listing_id, :string
    add_column :properties, :price, :integer
    add_column :properties, :address, :string
    add_column :properties, :city, :string
    add_column :properties, :zip, :string
    add_column :properties, :state, :string
    add_column :properties, :area, :integer
    add_column :properties, :date, :timestamp
    add_column :properties, :beds, :integer
    add_column :properties, :baths, :integer
    add_column :properties, :carports, :integer
  end
end
