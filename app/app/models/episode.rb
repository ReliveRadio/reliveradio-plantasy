class Episode < ActiveRecord::Base
	before_destroy :ensure_save_destroy
	before_destroy :remove_cache

	belongs_to :podcast
	has_many :playlist_entries, dependent: :destroy

	validates_associated :podcast
	validates :podcast_id, presence: true

	validates :guid, presence: true
	validates :title, presence: true
	validates :link, presence: true
	validates :pub_date, presence: true
	validates :audio_file_url, presence: true

	# def icon_url
	# 	self[:icon_url] || podcast.logo_url
	# end

	def icon_url_podcast_fallback
		icon_url || podcast.try(:logo_url)
	end

	def playcount
		self.playlist_entries.count
	end

	def last_played
		self.playlist_entries.maximum(:start_time)
	end

	def remove_cache
		if cached?
			# TODO check if it is in any future playlist

			# delete file from disk
			File.delete(local_path) rescue false
			# update database entry
			self.cached = false
			self.local_path = nil
			save
		end
	end

private
	def ensure_save_destroy
		save_to_destroy = true
		# do not destroy episodes that are mapped to a playlist entry that is in danger zone
		playlist_entries.each do |entry|
			save_to_destroy = false if entry.isInDangerZone?
		end
		return save_to_destroy
	end

end
