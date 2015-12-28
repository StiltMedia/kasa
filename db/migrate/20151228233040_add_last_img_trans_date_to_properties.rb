class AddLastImgTransDateToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :last_img_trans_date, :timestamp
  end
end
