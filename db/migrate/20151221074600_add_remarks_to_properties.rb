class AddRemarksToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :remarks, :text
  end
end
