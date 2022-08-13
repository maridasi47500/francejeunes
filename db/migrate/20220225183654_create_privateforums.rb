class CreatePrivateforums < ActiveRecord::Migration[6.0]
  def change
    create_table :privateforums do |t|
      t.text :content
      t.string :title
      t.integer :member_id
      t.timestamps
    end
    create_table :privatemessages do |t|
      t.integer :privateforum_id
      t.text :content
      t.string :title
      t.integer :member_id
      t.timestamps
    end
  end
end
