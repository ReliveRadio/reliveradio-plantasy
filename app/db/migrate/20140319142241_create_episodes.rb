class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
      t.string :title
      t.string :link
      t.datetime :pub_date
      t.string :guid
      t.string :subtitle
      t.text :content
      t.integer :duration
      t.string :flattr_url
      t.string :tags
      t.string :icon_url
      t.string :audio_file_url
      t.boolean :cached, default: false
      t.string :audio

      t.integer :podcast_id

      t.timestamps
    end
    add_index :episodes, [:guid], :unique => true
    add_index :episodes, [:podcast_id]
  end
end
