class Episode < ActiveRecord::Base
	belongs_to :podcast

	before_destroy :remove_cache

	def remove_cache
		EpisodesController.helpers.remove_cache(self)
	end
end
