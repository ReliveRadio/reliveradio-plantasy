require 'humantime'

class PlaylistEntry < ActiveRecord::Base
	belongs_to :episode
	belongs_to :jingle
	belongs_to :channel_playlist

	acts_as_list :scope => :channel_playlist

	validates :start_time, presence: true
	validates :end_time, presence: true
	validates :channel_playlist_id, presence: true

	validates_numericality_of :episode_id, allow_nil: true
    validates_numericality_of :jingle_id, allow_nil: true
    validate :episode_or_jingle # ensure that this is either an episode OR a jingle. Never both.

	def isLive?
		((start_time < Time.now) && (end_time > Time.now))
	end

	def duration
		self.episode.duration
	end

	def time_left
		if isLive?
			(end_time - Time.now).round
		else
			(end_time - start_time).round
		end
	end

	def time_left_human
		HumanTime.output time_left
	end

  private
    def episode_or_jingle
      if !(episode.blank? ^ jingle.blank?)
        errors.add(:base, "Specify an episode or a jingle, not both")
      end
    end
end
