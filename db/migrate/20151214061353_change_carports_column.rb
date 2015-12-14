class ChangeCarportsColumn < ActiveRecord::Migration
  def change
    rename_column :properties, :carports, :garage
  end
end
