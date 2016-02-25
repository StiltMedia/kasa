class AddUserIdToHits < ActiveRecord::Migration
  def change
    add_column :hits, :user_id, :integer
  end
end
