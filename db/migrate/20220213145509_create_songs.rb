class CreateSongs < ActiveRecord::Migration[6.0]
  def change
    create_table :songs do |t|
      t.string :title
      t.integer :artist_id
      t.timestamps
    end
    create_table :artists do |t|
      t.string :name
      t.timestamps
    end
  end
end
