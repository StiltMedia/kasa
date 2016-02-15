class AddApprovedToAdverts < ActiveRecord::Migration
  def change
    add_column :adverts, :approved, :boolean
  end
end
