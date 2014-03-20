class Podcast < ActiveRecord::Base
	has_many :episodes, :dependent => :destroy
end
