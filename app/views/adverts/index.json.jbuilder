json.array!(@adverts) do |advert|
  json.extract! advert, :id, :user_id, :property_id, :seed
  json.url advert_url(advert, format: :json)
end
