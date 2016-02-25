class ChangeStartTimeOpenHouseTimes < ActiveRecord::Migration

  def change
    change_column :open_house_times, :start_time, :string
    change_column :open_house_times, :end_time, :string
  end

end
