class AddAddressFreeformToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :address_freeform, :string
  end
end
