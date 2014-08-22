json.array!(@jingles) do |jingle|
  json.extract! jingle, :id, :title, :duration, :audio_path
  json.url jingle_url(jingle, format: :json)
end
