class CreateJingles < ActiveRecord::Migration
  def change
    create_table :jingles do |t|
      t.string :title
      t.integer :duration
      t.string :audio_path

      t.timestamps
    end
  end
end
