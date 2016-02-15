class AddSeedToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :seed, :boolean
  end
end
