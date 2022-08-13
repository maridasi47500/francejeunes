class AddMemberIdToArtists < ActiveRecord::Migration[6.0]
  def change
    add_column :artists, :member_id, :integer
  end
end
