class AddUpdatememberIdToPrivateforums < ActiveRecord::Migration[6.0]
  def change
    add_column :privateforums, :updatemember_id, :integer
  end
end
