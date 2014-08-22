class AddJingleIdToPlaylistEntry < ActiveRecord::Migration
  def change
    add_column :playlist_entries, :jingle_id, :integer
    add_index :playlist_entries, [:jingle_id]
  end
end
