class AddContactInformationToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :contact_information, :string
  end
end
