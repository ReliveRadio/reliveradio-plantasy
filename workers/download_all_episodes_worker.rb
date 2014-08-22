class DownloadAllEpisodesWorker
	include Sidekiq::Worker

	def perform(podcast_id)
		podcast = Podcast.find(podcast_id)
		podcast.episodes.each do |episode|
			if !episode.cached?
				DownloadEpisodeWorker.perform_async(episode.id)
			end
		end	
	end
end