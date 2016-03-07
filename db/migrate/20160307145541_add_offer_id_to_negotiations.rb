class AddOfferIdToNegotiations < ActiveRecord::Migration
  def change
    add_column :negotiations, :offer_id, :integer
  end
end
