class AddDateofbirthToMembers < ActiveRecord::Migration[6.0]
  def change
    add_column :members, :dateofbirth, :date
  end
end
