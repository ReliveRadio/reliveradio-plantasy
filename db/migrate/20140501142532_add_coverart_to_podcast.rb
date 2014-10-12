class AddCoverartToPodcast < ActiveRecord::Migration
  def change
    add_column :podcasts, :coverart, :string
  end
end
