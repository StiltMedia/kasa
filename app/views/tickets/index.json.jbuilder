json.array!(@tickets) do |ticket|
  json.extract! ticket, :id, :state, :subject
  json.url ticket_url(ticket, format: :json)
end
