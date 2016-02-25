json.array!(@negotiations) do |negotiation|
  json.extract! negotiation, :id, :src, :dst, :details, :ndate
  json.url negotiation_url(negotiation, format: :json)
end
