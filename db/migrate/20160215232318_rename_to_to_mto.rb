class RenameToToMto < ActiveRecord::Migration
  def change
    rename_column :memos, :to, :mto
  end
end
