class NewFeedWorker
	include Sidekiq::Worker

	# add a new podcast to the database by its feed url
	# afterwards start new task which imports all its episodes
	def perform(feed_url)
		feed = Feedjira::Feed.fetch_and_parse(feed_url)
		feed.sanitize_entries! # escape all harmful stuff
		unless Podcast.exists? :title => feed.title
			podcast = Podcast.create!(
				title: feed.title,
				website: feed.url,
				feed: feed.feed_url,
				description: feed.itunes_summary,
				logo_url: feed.logo_url,
				tags: feed.itunes_keywords,
				category: feed.itunes_category,
				author: feed.itunes_author,
				subtitle: feed.itunes_subtitle,
				language: feed.language
			)
			# fetch episodes in the background with sidekiq
	    	UpdateFeedWorker.perform_async(podcast.id)
		end
	end
end