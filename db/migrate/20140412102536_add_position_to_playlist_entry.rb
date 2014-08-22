class AddPositionToPlaylistEntry < ActiveRecord::Migration
  def change
    add_column :playlist_entries, :position, :integer
  end
end
