class AddSysidToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :sysid, :string
  end
end
