class AddNonRetsToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :non_rets, :boolean
  end
end
