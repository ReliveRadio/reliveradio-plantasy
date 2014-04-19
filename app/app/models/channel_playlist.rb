class ChannelPlaylist < ActiveRecord::Base
	has_many :playlist_entries

    validates :author, presence: true
    validates :name, presence: true
    validates :description, presence: true
	validates :language, presence: true
	validates :stream_url, presence: true
	validates :mpd_socket_path, presence: true

end
