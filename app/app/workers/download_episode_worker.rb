require 'open-uri'
require 'uri'
require 'ruby-mpd'
require 'audioinfo'

class DownloadEpisodeWorker
	include Sidekiq::Worker

	def perform(episode_id)
		episode = Episode.find(episode_id)
		uri = URI.parse(episode.audio_file_url)
		filename = File.basename(uri.path)
    	episode.local_path = '/home/vagrant/music/' + filename
		open(episode.local_path, 'wb') do |file|
      		file << open(episode.audio_file_url).read
    	end
    	episode.cached = true

    	# read duration from audio file
		AudioInfo.open(episode.local_path) do |info|
		  #info.artist   # or info["artist"]
		  #info.title    # or info["title"]
		  episode.duration = info.length   # playing time of the file
		  #info.bitrate  # average bitrate
		  #info.to_h     # { "artist" => "artist", "title" => "title", etc... }
		end

    	episode.save
	end
end