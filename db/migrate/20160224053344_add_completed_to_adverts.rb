class AddCompletedToAdverts < ActiveRecord::Migration
  def change
    add_column :adverts, :completed, :boolean
  end
end
