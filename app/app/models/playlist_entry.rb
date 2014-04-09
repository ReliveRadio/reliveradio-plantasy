class PlaylistEntry < ActiveRecord::Base
	belongs_to :episode
	belongs_to :channel_playlist

	validates :start_time, presence: true
	validates :end_time, presence: true
	validates :episode_id, presence: true
	validates :channel_playlist_id, presence: true

	def isLive?
		((start_time < Time.now) && (end_time > Time.now))
	end

	def duration
		self.episode.duration
	end
end
