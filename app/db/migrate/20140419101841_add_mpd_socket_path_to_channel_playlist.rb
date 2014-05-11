class AddMpdSocketPathToChannelPlaylist < ActiveRecord::Migration
  def change
    add_column :channel_playlists, :mpd_socket_path, :string
  end
end
