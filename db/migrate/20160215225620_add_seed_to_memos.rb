class AddSeedToMemos < ActiveRecord::Migration
  def change
    add_column :memos, :seed, :boolean
  end
end
