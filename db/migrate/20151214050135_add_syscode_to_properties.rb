class AddSyscodeToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :syscode, :string
  end
end
