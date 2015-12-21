class AddPtypeToToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :ptype, :string
  end
end
