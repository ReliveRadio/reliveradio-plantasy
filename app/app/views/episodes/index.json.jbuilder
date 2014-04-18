json.array!(@episodes) do |episode|
  json.extract! episode, :id, :title, :link, :pub_date, :guid, :subtitle, :content, :duration, :flattr_url, :tags, :icon_url, :audio_file_url, :cached, :local_path
  json.url episode_url(episode, format: :json)
end
