class AddAimeToMember < ActiveRecord::Migration[6.0]
  def change
    add_column :members, :aime, :string
  end
end
