class AddSeedToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :seed, :boolean
  end
end
