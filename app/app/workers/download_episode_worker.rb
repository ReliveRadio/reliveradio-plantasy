require 'open-uri'
require 'uri'
require 'ruby-mpd'
require 'audioinfo'

class DownloadEpisodeWorker
	include Sidekiq::Worker
	include Sidekiq::Status::Worker

	def perform(episode_id)
		episode = Episode.find(episode_id)
		url = URI.parse(episode.audio_file_url)
		filename = File.basename(url.path)
    	episode.local_path = '/home/vagrant/music/' + filename

    	Net::HTTP.new(url.host, url.port).request_get(url.path) do |response|
    		filesize = response['Content-Length'].to_i
    		bytes_done = 0

			open(episode.local_path, 'wb') do |file|
	    		response.read_body do |fragment|
	    			file << fragment
	    			# update status
	    			bytes_done += fragment.length
	    			at bytes_done, filesize
	    		end
	    	end
    	end

    	episode.cached = true

    	if episode.duration.blank?
			AudioInfo.open(episode.local_path) do |info|
			  #info.artist   # or info["artist"]
			  #info.title    # or info["title"]
			  episode.duration = info.length   # playing time of the file
			  #info.bitrate  # average bitrate
			  #info.to_h     # { "artist" => "artist", "title" => "title", etc... }
			end
    	end

    	episode.save

		mpd = MPD.new
		mpd.connect
		mpd.update
	end

end