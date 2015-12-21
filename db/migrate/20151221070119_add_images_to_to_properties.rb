class AddImagesToToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :images_tot, :integer
  end
end
