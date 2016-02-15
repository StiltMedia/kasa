json.array!(@feeds) do |feed|
  json.extract! feed, :id, :message, :user_id
  json.url feed_url(feed, format: :json)
end
