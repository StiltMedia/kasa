class RemoveSysodeFromProperties < ActiveRecord::Migration
  def change
    remove_column :properties, :syscode, :string
  end
end
