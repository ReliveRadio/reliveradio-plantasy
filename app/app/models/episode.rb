class Episode < ActiveRecord::Base
	before_destroy :ensure_save_destroy
	before_destroy :remove_audio_file_cache
	before_destroy :remove_thumbs

	belongs_to :podcast
	has_many :playlist_entries, dependent: :destroy

	validates_associated :podcast
	validates :podcast_id, presence: true

	validates :guid, presence: true
	validates :title, presence: true
	validates :link, presence: true
	validates :pub_date, presence: true
	validates :audio_file_url, presence: true

	mount_uploader :coverart, CoverArtUploader
	mount_uploader :audio, AudioUploader

	def playcount
		self.playlist_entries.count
	end

	def last_played
		self.playlist_entries.maximum(:start_time)
	end

	def cached?
		!self.audio.url.blank?
	end

	def remove_audio_file_cache
		if cached?
			self.remove_audio!
			self.save
		end
	end

private
	def ensure_save_destroy
		save_to_destroy = true
		# do not destroy episodes that are mapped to a playlist entry that is in danger zone
		self.playlist_entries.each do |entry|
			save_to_destroy = false if entry.isInDangerZone?
		end
		return save_to_destroy
	end

	def remove_thumbs
		self.remove_coverart!
		self.save
	end

end
