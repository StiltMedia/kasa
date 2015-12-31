class AddRequestOneYearHomeWarrantyToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :request_one_year_home_warranty, :string
  end
end
