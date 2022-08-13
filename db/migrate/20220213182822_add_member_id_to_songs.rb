class AddMemberIdToSongs < ActiveRecord::Migration[6.0]
  def change
    add_column :songs, :member_id, :integer
    add_column :songs, :content, :text
    add_column :songs, :contentmember_id, :integer
  end
end
