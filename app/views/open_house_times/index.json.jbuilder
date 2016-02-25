json.array!(@open_house_times) do |open_house_time|
  json.extract! open_house_time, :id, :odate, :start_time, :end_time, :advert_id
  json.url open_house_time_url(open_house_time, format: :json)
end
