class CreatePlaylistEntries < ActiveRecord::Migration
  def change
    create_table :playlist_entries do |t|
      t.datetime :start_time
      t.boolean :premiere
      t.datetime :end_time

      t.integer :channel_playlist_id
      t.integer :episode_id

      t.timestamps
    end
  end
end
