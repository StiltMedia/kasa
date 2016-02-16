class AddMfromToMemos < ActiveRecord::Migration
  def change
    add_column :memos, :mfrom, :integer
  end
end
