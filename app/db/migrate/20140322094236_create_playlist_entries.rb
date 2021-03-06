class CreatePlaylistEntries < ActiveRecord::Migration
  def change
    create_table :playlist_entries do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.boolean :premiere, default: false

      t.integer :channel_playlist_id
      t.integer :episode_id

      t.timestamps
    end
    add_index :playlist_entries, [:channel_playlist_id]
    add_index :playlist_entries, [:episode_id]
  end
end
