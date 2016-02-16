class AddTuserToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :tuser, :integer
  end
end
