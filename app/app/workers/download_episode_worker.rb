require 'open-uri'
require 'uri'
require 'ruby-mpd'
require 'fileutils'
require 'taglib'

class DownloadEpisodeWorker
	include Sidekiq::Worker

	def perform(episode_id)
		# prepare download url and local path
		episode = Episode.find(episode_id)
		podcast = episode.podcast
		
		# DOWNLOAD
		episode.remote_audio_url = episode.audio_file_url
		episode.save
		episode.cached

		# AUDIOFILE TAGGING

		# Set tags of the file based on feed data
		# this data is later used by mpd and transferred to icecast
		# users of webradio see this data as currently played song
		TagLib::FileRef.open(episode.audio.url) do |fileref|
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