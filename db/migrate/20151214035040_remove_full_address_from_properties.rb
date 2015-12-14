class RemoveFullAddressFromProperties < ActiveRecord::Migration
  def change
    remove_column :properties, :full_address, :string
  end
end
