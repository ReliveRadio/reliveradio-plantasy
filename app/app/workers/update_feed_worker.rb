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
						podcast_id: podcast.id,

						title: episode.title,
						link: episode.url,
						subtitle: episode.summary,
						content: episode.content,
						pub_date: episode.published,
						#filesize_in_bytes: episode.filesize_in_bytes,
						#duration: episode.duration,
						flattr_url: episode.flattr_url,
						#tags: episode.tags,
						icon_url: episode.icon_url,
						audio_file_url: episode.audio_file_url,
						cached: false
					)
				end
			end
		end
	end
end