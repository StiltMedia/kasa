class ChangeOdateInOpenHouseTimes < ActiveRecord::Migration
  def change
    change_column :open_house_times, :odate, :string
  end
end
