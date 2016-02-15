class AddSeedToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :seed, :boolean
  end
end
