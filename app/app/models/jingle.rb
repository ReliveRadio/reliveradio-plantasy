class Jingle < ActiveRecord::Base
	has_many :playlist_entries

	validates :title, presence: true
	validates :audio, presence: true
	validates :duration, presence: true

	mount_uploader :audio, AudioUploader
	
	before_destroy :remove_uploaded_audio
	
	def playcount
		playlist_entries.count
	end

	private
	  def remove_uploaded_audio
		# delete file from disk
		remove_audio!
	  end
end
