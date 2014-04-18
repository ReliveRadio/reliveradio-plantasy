class Podcast < ActiveRecord::Base
	has_many :episodes, :dependent => :destroy

	validates :feed, presence: true
	validates :title, presence: true
	validates :logo_url, presence: true
	validates :website, presence: true

end
