class NullifyFromTo < ActiveRecord::Migration
  def change
    Memo.update_all(mfrom: nil)
    Memo.update_all(mto: nil)
  end
end
