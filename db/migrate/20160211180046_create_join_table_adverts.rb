class CreateJoinTableAdverts < ActiveRecord::Migration
  def change
    create_join_table :properties, :users do |t|
      # t.index [:property_id, :user_id]
      # t.index [:user_id, :property_id]
    end
  end
end
