class ChangeMfromAndMtoToInteger < ActiveRecord::Migration
  def change
    change_column :memos, :mfrom, 'integer USING CAST(mfrom AS integer)'
    change_column :memos, :mto, 'integer USING CAST(mto AS integer)'
  end
end
