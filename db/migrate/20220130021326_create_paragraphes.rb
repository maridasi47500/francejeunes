class CreateParagraphes < ActiveRecord::Migration[6.0]
  def change
    create_table :paragraphes do |t|
      t.integer :article_id
      t.text :content
      t.timestamps
    end
  end
end
