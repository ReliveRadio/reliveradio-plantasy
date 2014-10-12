class RemoveTagsAndCategoryFromPodcasts < ActiveRecord::Migration
  def change
    remove_column :podcasts, :tags, :string
    remove_column :podcasts, :category, :string
  end
end
