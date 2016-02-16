json.array!(@memos) do |memo|
  json.extract! memo, :id, :from, :to, :body, :ticket_id
  json.url memo_url(memo, format: :json)
end
