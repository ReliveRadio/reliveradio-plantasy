class Jingle < ActiveRecord::Base
	has_many :playlist_entries
	mount_uploader :audio, AudioUploader
	before_destroy :remove_uploaded_audio
	
	def playcount
		self.playlist_entries.count
	end

	private
	  def remove_uploaded_audio
	  	remove_audio!
    	save
	  end
end
