class RenameFromTomfrom < ActiveRecord::Migration
  def change
    rename_column :memos, :from, :mfrom
  end
end
