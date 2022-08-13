class CreateMemberhavephotos < ActiveRecord::Migration[6.0]
  def change
    create_table :photos do |t|
      t.string :title
      t.string :image
      t.integer :member_id
      t.timestamps
    end
  end
end
