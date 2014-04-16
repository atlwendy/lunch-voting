json.array!(@meetings) do |meeting|
  json.extract! meeting, :id, :title, :description, :date
  json.url meeting_url(meeting, format: :json)
end
