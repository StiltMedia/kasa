class AddReviewedToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :reviewed, :boolean
  end
end
