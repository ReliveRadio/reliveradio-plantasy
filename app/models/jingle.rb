class Jingle < ActiveRecord::Base
	before_destroy :ensure_save_destroy
	before_destroy :remove_uploaded_audio
	
	has_many :playlist_entries

	validates :title, presence: true
	validates :duration, presence: true

	mount_uploader :audio, AudioUploader
	
	def playcount
		self.playlist_entries.count
	end

	private
	  def remove_uploaded_audio
		# delete file from disk
		self.remove_audio!
		self.save
	  end

	  def ensure_save_destroy
		save_to_destroy = true
		# do not destroy episodes that are mapped to a playlist entry that is in danger zone
		self.playlist_entries.each do |entry|
			save_to_destroy = false if entry.isInDangerZone?
		end
		return save_to_destroy
	end
end
