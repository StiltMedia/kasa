class AddLiveToAdverts < ActiveRecord::Migration
  def change
    add_column :adverts, :live, :boolean
  end
end
