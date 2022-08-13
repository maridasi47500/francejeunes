class CreateForumcats < ActiveRecord::Migration[6.0]
  def change
    create_table :forumcats do |t|
      t.string :name
      t.timestamps
    end
    create_table :forumsubcats do |t|
      t.integer :forumcat_id
      t.string :name
      t.timestamps
    end
  end
end
