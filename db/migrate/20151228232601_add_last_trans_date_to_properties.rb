class AddLastTransDateToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :last_trans_date, :timestamp
  end
end
