json.array!(@podcasts) do |podcast|
  json.extract! podcast, :id, :title, :description, :logo_url, :website, :feed, :tags, :category
  json.url podcast_url(podcast, format: :json)
end
