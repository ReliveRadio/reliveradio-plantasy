class AddStreamUrlToChannelPlaylist < ActiveRecord::Migration
  def change
    add_column :channel_playlists, :stream_url, :string
  end
end
