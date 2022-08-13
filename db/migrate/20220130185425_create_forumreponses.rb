class CreateForumreponses < ActiveRecord::Migration[6.0]
  def change
    create_table :forumcommentaires do |t|
      t.integer :forum_id
      t.integer :member_id
      t.string :title
      t.text :content
      t.timestamps
    end
  end
end
