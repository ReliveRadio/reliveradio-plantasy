class RemoveTagsFromEpisodes < ActiveRecord::Migration
  def change
    remove_column :episodes, :tags, :string
  end
end
