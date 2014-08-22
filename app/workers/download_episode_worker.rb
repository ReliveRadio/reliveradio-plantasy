class DownloadEpisodeWorker
	include Sidekiq::Worker

	def perform(episode_id)
		# prepare download url and local path
		episode = Episode.find(episode_id)
		
		# DOWNLOAD
		episode.remote_audio_url = episode.audio_file_url
		episode.save
	end
end