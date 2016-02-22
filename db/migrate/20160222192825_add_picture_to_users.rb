class AddPictureToUsers < ActiveRecord::Migration
  def change
    add_column :users, :picture, :binary
    add_column :users, :picture_content_type, :string
    add_column :users, :picture_file_name, :string
  end
end
