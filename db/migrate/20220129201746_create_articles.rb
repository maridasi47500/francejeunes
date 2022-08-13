class CreateArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.string :subtitle
      t.text :content
      t.integer :member_id
      t.timestamps
    end
  end
end
