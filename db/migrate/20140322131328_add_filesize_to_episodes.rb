class AddFilesizeToEpisodes < ActiveRecord::Migration
  def change
    add_column :episodes, :filesize, :integer
  end
end
