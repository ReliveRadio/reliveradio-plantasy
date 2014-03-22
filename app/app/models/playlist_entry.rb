class PlaylistEntry < ActiveRecord::Base
	belongs_to :episode
	belongs_to :channel_playlist
end
