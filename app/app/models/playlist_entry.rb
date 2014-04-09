class PlaylistEntry < ActiveRecord::Base
	belongs_to :episode
	belongs_to :channel_playlist
	def isLive?
		((start_time < Time.now) && (end_time > Time.now))
	end

	def duration
		self.episode.duration
	end
end
