class AddCoverartToChannelPlaylist < ActiveRecord::Migration
  def change
    add_column :channel_playlists, :coverart, :string
  end
end
