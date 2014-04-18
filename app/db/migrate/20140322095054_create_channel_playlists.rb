class CreateChannelPlaylists < ActiveRecord::Migration
  def change
    create_table :channel_playlists do |t|
      t.string :author
      t.string :name
      t.text :description
      t.string :language

      t.timestamps
    end
  end
end
