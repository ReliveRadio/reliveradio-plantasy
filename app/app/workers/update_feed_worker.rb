require 'chronic_duration'

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
					if !episode.itunes_duration.blank?
						duration = ChronicDuration.parse(episode.itunes_duration)
					end
					new_episode = Episode.create!(
						guid: episode.id,
						podcast_id: podcast.id,

						title: episode.title,
						link: episode.url,
						subtitle: episode.summary,
						content: episode.content,
						pub_date: episode.published,
						filesize: episode.enclosure_length,
						duration: duration,
						flattr_url: episode.flattr_url,
						tags: episode.itunes_keywords,
						icon_url: episode.itunes_image,
						audio_file_url: episode.enclosure_url,
					)
					# download coverart
					if !new_episode.icon_url.blank?
						new_episode.remote_coverart_url = new_episode.icon_url
						new_episode.save
					end
				end
			end
		end
	end
end