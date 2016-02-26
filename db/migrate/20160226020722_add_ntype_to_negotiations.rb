class AddNtypeToNegotiations < ActiveRecord::Migration
  def change
    add_column :negotiations, :ntype, :string
  end
end
