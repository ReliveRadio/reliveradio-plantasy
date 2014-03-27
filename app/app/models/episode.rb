class Episode < ActiveRecord::Base
	belongs_to :podcast
	validates_associated :podcast

	validates :title, presence: true
	validates :link, presence: true
	validates :pub_date, presence: true
	validates :guid, presence: true
	validates :audio_file_url, presence: true

	before_destroy :remove_cache

	def remove_cache
		EpisodesController.helpers.remove_cache(self)
	end

end
