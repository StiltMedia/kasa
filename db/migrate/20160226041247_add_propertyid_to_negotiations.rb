class AddPropertyidToNegotiations < ActiveRecord::Migration
  def change
    add_column :negotiations, :property_id, :integer
  end
end
