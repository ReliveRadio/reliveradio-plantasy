class AddIcecastMountpointToChannelPlaylist < ActiveRecord::Migration
  def change
    add_column :channel_playlists, :icecast_mountpoint, :string
  end
end
