class UpdateFeedWorker
	include Sidekiq::Worker

	# check for new episodes of the given podcast and import them
	# into the database
	def perform(podcast_id)
		podcast = Podcast.find(podcast_id)
		if !podcast.blank?
			feed = Feedjira::Feed.fetch_and_parse(podcast.feed)
			feed.sanitize_entries! # escape all harmful stuff
			feed.entries.each do |episode|
				unless Episode.exists? :guid => episode.id
					Episode.create!(
						guid: episode.id,
						title: episode.title,
						subtitle: episode.summary,
						content: episode.content,
						#pub_date: episode.published,
						cached: false,
						podcast_id: podcast.id
					)
				end
			end
		end
	end
end