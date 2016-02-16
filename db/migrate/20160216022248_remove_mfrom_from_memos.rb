class RemoveMfromFromMemos < ActiveRecord::Migration
  def change
    remove_column :memos, :mfrom, :integer
  end
end
