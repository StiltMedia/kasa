class AddSeedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :seed, :boolean
  end
end
