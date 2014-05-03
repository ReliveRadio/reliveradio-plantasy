require 'humantime'

class PlaylistEntry < ActiveRecord::Base
    before_destroy :ensure_save_destroy

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

    # do not change playlist entries that are live or have < 30 minutes playtime left
    def isInDangerZone?
    	(start_time < Time.zone.now + 30.minutes)
    end

	def isLive?
		((start_time < Time.zone.now) && (end_time > Time.zone.now))
	end

	def is_episode?
		!episode_id.blank?
	end

	def is_jingle?
		!jingle_id.blank?
	end

	def duration
		return episode.duration if is_episode?
		return jingle.duration if is_jingle?
	end

	def time_left
		if isLive?
			(end_time - Time.zone.now).round
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

    def ensure_save_destroy
    	!isInDangerZone?
    end
    
end
