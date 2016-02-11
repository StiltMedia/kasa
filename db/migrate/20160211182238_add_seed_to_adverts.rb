class AddSeedToAdverts < ActiveRecord::Migration
  def change
    add_column :adverts, :seed, :boolean
  end
end
