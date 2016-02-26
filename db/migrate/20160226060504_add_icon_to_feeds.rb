class AddIconToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :icon, :string
  end
end
