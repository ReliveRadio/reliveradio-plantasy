json.array!(@channel_playlists) do |channel_playlist|
  json.extract! channel_playlist, :id, :author, :name, :description, :language
  json.url channel_playlist_url(channel_playlist, format: :json)
end
