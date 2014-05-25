include ApplicationHelper

class PlaylistEntry < ActiveRecord::Base
    before_destroy :ensure_save_destroy
    before_destroy :update_list

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
    	(self.start_time < Time.zone.now + 30.minutes)
    end

	def is_live?
		((self.start_time < Time.zone.now) && (self.end_time > Time.zone.now))
	end

	def is_episode?
		!self.episode_id.blank?
	end

	def is_jingle?
		!self.jingle_id.blank?
	end

	def duration
		return self.episode.duration if is_episode?
		return self.jingle.duration if is_jingle?
	end

	def time_left
		if is_live?
			(self.end_time - Time.zone.now).round
		else
			(self.end_time - self.start_time).round
		end
	end

	def time_passed
		self.duration - self.time_left
	end

	# returns how much playtime is left as 0-100%
	def percent_left
		((self.time_passed.to_f / self.duration) * 100).round
	end

	def time_left_human
		humanize_simplify time_left
	end

  private
    def episode_or_jingle
      if !(self.episode.blank? ^ self.jingle.blank?)
        errors.add(:base, "Specify an episode or a jingle, not both")
      end
    end

    def ensure_save_destroy
    	!isInDangerZone?
    end

    def update_list
		# adjust all start and end times of all episodes after the entry
		# start time for the entry AFTER the deleted one has to be end time of the entry BEFORE the deleted one
		temp_start_time = self.higher_item.end_time
		# update all after entries play times
		self.lower_items.each do |entry|
			entry.start_time = temp_start_time
			entry.end_time = temp_start_time + entry.episode.duration.seconds if entry.is_episode?
			entry.end_time = temp_start_time + entry.jingle.duration.seconds if entry.is_jingle?
			entry.save
			temp_start_time = entry.end_time
		end
		# remove entry
		self.remove_from_list
    end
    
end
