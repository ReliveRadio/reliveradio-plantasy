json.array!(@playlist_entries) do |playlist_entry|
  json.extract! playlist_entry, :id, :start_time, :premiere
  json.url playlist_entry_url(playlist_entry, format: :json)
end
