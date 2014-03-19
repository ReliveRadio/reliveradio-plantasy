class Podcast < ActiveRecord::Base
	has_many :episodes
end
