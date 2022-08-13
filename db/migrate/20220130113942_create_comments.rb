class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.integer :member_id
      t.integer :article_id
      t.text :content
      t.string :title
      t.timestamps
    end
  end
end
