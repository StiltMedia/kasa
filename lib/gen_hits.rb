
(1..30).each do |i|
  puts "#{i} "
  (rand(0..20)).times do
    property = Property.where(seed: true).sample(1)[0]
    user_id = nil
    user_id = Advert.where(property_id: property.id).last.user_id if Advert.where(property_id: property.id).last.user_id
    Hit.create(
      property_id: property.id,
      htime: Time.at(1454306726)+rand(0..i).days,
      user_id: user_id 
    )
  end
end
