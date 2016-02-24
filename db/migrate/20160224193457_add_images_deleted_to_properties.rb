class AddImagesDeletedToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :images_deleted, :text
  end
end
