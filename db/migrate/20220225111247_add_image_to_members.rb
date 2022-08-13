class AddImageToMembers < ActiveRecord::Migration[6.0]
  def change
    add_column :members, :image, :string
  end
end
