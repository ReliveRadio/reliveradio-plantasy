class Podcast < ActiveRecord::Base
	before_destroy :ensure_save_destroy

	has_many :episodes, :dependent => :destroy

	validates :feed, presence: true
	validates :title, presence: true
	validates :logo_url, presence: true
	validates :website, presence: true


	private
		def ensure_save_destroy
			Rails.logger.info episodes.inspect
			# ensure that non of the episodes of this podcast is in danger zone
			episodes.each do |episode|
				episode.playlist_entries.each do |entry|
					return false if entry.isInDangerZone?
				end
			end
		end
end
