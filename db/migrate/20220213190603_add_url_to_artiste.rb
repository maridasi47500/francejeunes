class AddUrlToArtiste < ActiveRecord::Migration[6.0]
  def change
    add_column :artists, :url, :string
    add_column :songs, :url, :string
  end
end
