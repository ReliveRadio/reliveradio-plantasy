class Podcast < ActiveRecord::Base
	has_many :episodes, :dependent => :destroy

	validates :feed, presence: true
	validates :title, presence: true
	validates :logo_url, presence: true
	validates :website, presence: true

	def self.search(search)
		if search
			where('title LIKE ?', "%#{search}%")
		else
			scoped # like all but without doing the query
		end
	end
end
