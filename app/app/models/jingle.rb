class Jingle < ActiveRecord::Base
	has_many :playlist_entries
	mount_uploader :audio, AudioUploader
	
	def playcount
		self.playlist_entries.count
	end
end
