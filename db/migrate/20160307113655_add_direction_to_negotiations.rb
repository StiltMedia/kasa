class AddDirectionToNegotiations < ActiveRecord::Migration
  def change
    add_column :negotiations, :direction, :string
  end
end
