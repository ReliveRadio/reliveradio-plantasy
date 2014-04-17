class Jingle < ActiveRecord::Base
	has_many :playlist_entries
	mount_uploader :audio, JingleUploader
	
	def playcount
		PlaylistEntry.where(jingle_id: self.id).count
	end
end
