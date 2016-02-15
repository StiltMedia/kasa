class SeedSomeHits < ActiveRecord::Migration
  def up
    Advert.all.each do |advert|
      rand(1..10).times do
        Hit.create(
          property_id: advert.property.id,
          kind: 'listing_details',
          created_at: rand(Time.now()-15.days..Time.now()+15.days)
        )
      end
    end
  end
end
