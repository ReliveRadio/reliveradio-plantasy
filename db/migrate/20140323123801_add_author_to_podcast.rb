class AddAuthorToPodcast < ActiveRecord::Migration
  def change
    add_column :podcasts, :author, :string
  end
end
