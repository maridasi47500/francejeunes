class CreateArticlestars < ActiveRecord::Migration[6.0]
  def change
    create_table :articlestars do |t|
      t.integer :star
      t.integer :member_id
      t.integer :article_id
      t.timestamps
    end
  end
end
