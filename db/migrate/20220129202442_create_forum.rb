class CreateForum < ActiveRecord::Migration[6.0]
  def change
    create_table :forums do |t|
      t.integer :forumsubcat_id
      t.integer :member_id
      t.string :title
      t.text :content
      t.timestamps
    end
  end
end
