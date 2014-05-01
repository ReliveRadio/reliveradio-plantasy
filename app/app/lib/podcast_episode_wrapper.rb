# This is a wrapper class to display podcasts and episodes as search results
# in a single array.

class PodcastEpisodeWrapper

	def initialize(podcast_or_episode)
		@object = podcast_or_episode
	end

	def coverart(version)
		@object.coverart.send(version)
	end

	def title
		@object.title
	end

	def subtitle
		@object.subtitle
	end

	def is_episode?
		@object.is_a? Episode
	end

	def is_podcast?
		@object.is_a? Podcast
	end

	def id
		@object.id
	end

end