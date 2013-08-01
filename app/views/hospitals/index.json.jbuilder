json.array!(@hospitals) do |hospital|
  json.extract! hospital, :name, :deleted
  json.url hospital_url(hospital, format: :json)
end
