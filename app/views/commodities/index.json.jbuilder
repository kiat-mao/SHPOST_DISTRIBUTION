json.array!(@commodities) do |commodity|
  json.extract! commodity, :id
  json.url commodity_url(commodity, format: :json)
end
