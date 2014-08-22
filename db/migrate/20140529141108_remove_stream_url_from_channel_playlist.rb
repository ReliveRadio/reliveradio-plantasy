class RemoveStreamUrlFromChannelPlaylist < ActiveRecord::Migration
  def change
    remove_column :channel_playlists, :stream_url, :string
  end
end
