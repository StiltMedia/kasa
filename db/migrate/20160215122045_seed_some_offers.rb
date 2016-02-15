class SeedSomeOffers < ActiveRecord::Migration
  def up
    user = User.find_by_email("guigo@stiltmedia.com")
    user.adverts.each do |advert|
      random_user = User.where("id != ?", user.id).sample(1)[0]
.id
      Offer.create(amount: "#{rand(20..200)}00000", funding_source: "With Mortgage", pre_approved: "Yes", down_payment: "1", standard_terms: nil, downpayment_days: nil, planning_inspections: nil, request_pest_report: nil, initial_deposit: nil, offer_expires: nil, special_instructions: nil, first_name: nil, last_name: nil, phone: nil, address: nil, user_id: random_user, property_id: advert.property_id, request_one_year_home_warranty: nil, reviewed: nil, seed: true)
    end
  end
end
