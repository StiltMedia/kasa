class SomeAdvertSeeds < ActiveRecord::Migration
  def up
    # Add some properties
    property = Property.create(
      listing_id: "FE9E" + "0001",
      price: 3495000,
      address: "3427 N Moorings Way",
      city: "Miami",
      zip: "33133",
      state: "FL",
      date: Time.now(),
      beds: 5,
      baths: 4,
      garage: 2,
      remarks: "Fetching ???South of France??? Villa perched in the fabled Moorings enclave w/private-access-only guard gate, 3 enchanting parks & community dock. Graciously scaled, sunlit interior distinguished by inlaid marble floors; vaulted, coffered &10 ft ceilings; French doors & terraced balconies. Formal living/dining rms; all-stainless/granite kitchen; spacious family rm; magnificent master suite. Maid's Quarters w/sep entry; laundry rm; 3-car garage; lge pool. Oaks, orchids & ornamentals frame this South Grove",
      seed: true,
      non_rets: true
    )
    user = User.find_by_email("guigo@stiltmedia.com")
    # Make entry in join table called adverts
    Advert.create(
      user_id: user.id,
      property_id: property.id,
      seed: true
    )
  end

  def down
    Property.destroy_all("listing_id LIKE '%FE9E%'")
  end
end
