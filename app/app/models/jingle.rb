class Jingle < ActiveRecord::Base
	has_many :playlist_entries
	mount_uploader :audio, JingleUploader
	
	def playcount
		self.playlist_entries.count
	end
end
