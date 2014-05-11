class AddCoverartToEpisode < ActiveRecord::Migration
  def change
    add_column :episodes, :coverart, :string
  end
end
