require 'open-uri'
require 'uri'
require 'ruby-mpd'
require 'audioinfo'
require 'fileutils'
require 'taglib'

class DownloadEpisodeWorker
	include Sidekiq::Worker

	def perform(episode_id)
		# prepare download url and local path
		episode = Episode.find(episode_id)
		podcast = episode.podcast

		uri = URI.parse(episode.audio_file_url)
		filename = File.basename(uri.path)
		episode.local_path = Rails.root.join('audio', podcast.title, filename).to_s
		
		# ensure folder for the podcast exists
		dirname = File.dirname(episode.local_path)
		unless File.directory?(dirname)
			FileUtils.mkdir_p(dirname)
		end
		# download the file
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

		# Set tags of the file based on feed data
		# this data is later used by mpd and transferred to icecast
		# users of webradio see this data as currently played song
		TagLib::FileRef.open(episode.local_path) do |fileref|
		  unless fileref.null?
			tag = fileref.tag

			tag.title = episode.title
			tag.artist = podcast.author
			tag.album = podcast.title
			tag.year = episode.pub_date.year
			#tag.track   #=> 7
			tag.genre = podcast.category
			#tag.comment #=> nil

			fileref.save # store tags in file
		  end
		end # File is automatically closed at block end		

		episode.save
	end
end