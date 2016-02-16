class RemoveMtoFromMemos < ActiveRecord::Migration
  def change
    remove_column :memos, :mto, :integer
  end
end
