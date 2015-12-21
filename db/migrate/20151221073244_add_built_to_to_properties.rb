class AddBuiltToToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :built, :string
  end
end
