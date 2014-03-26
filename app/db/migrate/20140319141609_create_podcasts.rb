class CreatePodcasts < ActiveRecord::Migration
  def change
    create_table :podcasts do |t|
      t.string :title
      t.text :description
      t.string :logo_url
      t.string :website
      t.string :feed
      t.string :tags
      t.string :category

      t.timestamps
    end
    add_index :podcasts, [:feed, :title], :unique => true
  end
end
