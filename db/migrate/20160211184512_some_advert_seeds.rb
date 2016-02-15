class SomeAdvertSeeds < ActiveRecord::Migration
  def up
    properties = []
    # Add some properties
    3.times do |i|
      properties << Property.create(
        listing_id: "FE9E" + "000#{i}",
        price: 3495000,
        address: "3427#{i} N Moorings Way",
        city: "Miami",
        zip: "3313#{i}",
        state: "FL",
        images_tot: 1,
        date: Time.at(Time.now().to_i - (rand(0..12)*60*60*24*30)),
        beds: 5,
        baths: 4,
        garage: 2,
        remarks: "Fetching ???South of France??? Villa perched in the fabled Moorings enclave w/private-access-only guard gate, 3 enchanting parks & community dock. Graciously scaled, sunlit interior distinguished by inlaid marble floors; vaulted, coffered &10 ft ceilings; French doors & terraced balconies. Formal living/dining rms; all-stainless/granite kitchen; spacious family rm; magnificent master suite. Maid's Quarters w/sep entry; laundry rm; 3-car garage; lge pool. Oaks, orchids & ornamentals frame this South Grove",
        seed: true,
        non_rets: true
      )
    end
    user = User.find_by_email("guigo@stiltmedia.com")
    properties.each do |p|
      # Make entry in join table called adverts
      Advert.create(
        user_id: user.id,
        property_id: p.id,
        seed: true
      )
    end
  end

  def down
    Property.where("listing_id LIKE '%FE9E%'").all.each do |p|
      Advert.where(property_id: p.id).destroy_all
      p.destroy
    end
  end
end
