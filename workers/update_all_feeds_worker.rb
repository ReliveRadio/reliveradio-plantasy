class UpdateAllFeedsWorker
	include Sidekiq::Worker

	def perform
		podcasts = Podcast.all
		podcasts.each do |podcast|
			# fetch episodes in the background with sidekiq
	    	UpdateFeedWorker.perform_async(podcast.id)
		end
	end
end