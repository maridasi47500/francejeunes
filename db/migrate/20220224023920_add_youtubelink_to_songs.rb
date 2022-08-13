class AddYoutubelinkToSongs < ActiveRecord::Migration[6.0]
  def change
    add_column :songs, :youtubelink_id, :string
    add_column :songs, :videomember_id, :integer
  end
end
