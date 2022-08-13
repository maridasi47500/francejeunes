class CreateVueforums < ActiveRecord::Migration[6.0]
  def change
    create_table :vueforums do |t|
      t.integer :member_id
      t.integer :forum_id
      t.timestamps
    end
  end
end
