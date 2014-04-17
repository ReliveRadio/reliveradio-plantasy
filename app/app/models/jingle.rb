class Jingle < ActiveRecord::Base
	has_many :playlist_entries

	def playcount
		PlaylistEntry.where(jingle_id: self.id).count
	end
end
