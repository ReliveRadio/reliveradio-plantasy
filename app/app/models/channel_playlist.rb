class ChannelPlaylist < ActiveRecord::Base
	has_many :playlist_entries
end
