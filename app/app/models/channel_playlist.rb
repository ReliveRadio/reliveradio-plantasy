class ChannelPlaylist < ActiveRecord::Base
	has_many :playlist_entries, :dependent => :destroy

    validates :author, presence: true
    validates :name, presence: true
    validates :description, presence: true
	validates :language, presence: true
	validates :icecast_mountpoint, presence: true
	validates :mpd_socket_path, presence: true

	mount_uploader :coverart, ChannelCoverArtUploader

end
