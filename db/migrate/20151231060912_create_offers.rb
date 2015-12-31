class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.string :amount
      t.string :funding_source
      t.string :pre_approved
      t.string :down_payment
      t.string :standard_terms
      t.string :downpayment_days
      t.string :planning_inspections
      t.string :request_pest_report
      t.string :initial_deposit
      t.string :offer_expires
      t.string :special_instructions
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :address
      t.references :user, index: true, foreign_key: true
      t.references :property, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
