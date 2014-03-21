require 'open-uri'
require 'uri'

class DownloadEpisodeWorker
	include Sidekiq::Worker

	# check for new episodes of the given podcast and import them
	# into the database
	def perform(episode_id)
		episode = Episode.find(episode_id)
		uri = URI.parse(episode.audio_file_url)
		filename = File.basename(uri.path)
    	episode.local_path = '/home/vagrant/music/' + filename
		open(episode.local_path, 'wb') do |file|
      		file << open(episode.audio_file_url).read
    	end
    	episode.cached = true
    	episode.save
	end
end