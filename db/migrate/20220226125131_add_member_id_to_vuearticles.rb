class AddMemberIdToVuearticles < ActiveRecord::Migration[6.0]
  def change
    add_column :vuearticles, :member_id, :integer
  end
end
