class AddSeedToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :seed, :boolean
  end
end
