class BackfillFeeds < ActiveRecord::Migration
  def up
    Feed.destroy_all
    # User creations
    User.all.each do |user|
      Feed.create(message: "User #{user.email} added to system.", created_at: rand(user.created_at-7.days..user.created_at+7.days), seed: true )
    end
    Advert.all.each do |advert|
      Feed.create( message: "#{advert.user.email} started creating listing #{advert.id}", created_at: rand(advert.created_at-7.days..advert.created_at+7.days), seed: true )
      Feed.create(user_id: advert.user.id, message: "Started creating listing #{advert.id}", created_at: rand(advert.created_at-7.days..advert.created_at+7.days), seed: true )
    end
    Hit.all.each do |hit|
      uid = Advert.where(property_id: hit.property_id).last.user_id
      Feed.create( user_id: uid, message: "Someone viewed property #{hit.property_id}", created_at: rand(hit.created_at-7.days..hit.created_at+7.days), seed: true ) if hit.kind == "listing_details"
    end
    Offer.all.each do |offer|
      Feed.create( message: "#{offer.user.email} initiated offer for property id #{offer.property.id}", created_at: rand(offer.created_at-7.days..offer.created_at+7.days), seed: true )
      Feed.create( message: "Initiated offer for property id #{offer.property.id}", created_at: rand(offer.created_at-7.days..offer.created_at+7.days), seed: true , user_id: offer.user.id)
    end
    
  end
end
