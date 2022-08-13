class AddImageToArticles < ActiveRecord::Migration[6.0]
  def change
    add_column :articles, :image, :string
    add_column :articles, :category_id, :integer
    create_table :categories do |t|
      t.string :name
    end
  end
end
