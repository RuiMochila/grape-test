json.array!(@cars) do |car|
  json.extract! car, :id, :name, :horse_power
  json.url car_url(car, format: :json)
end
