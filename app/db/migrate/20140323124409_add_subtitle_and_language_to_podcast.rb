class AddSubtitleAndLanguageToPodcast < ActiveRecord::Migration
  def change
    add_column :podcasts, :subtitle, :string
    add_column :podcasts, :language, :string
  end
end
