class AddNoprivateToArticles < ActiveRecord::Migration[6.0]
  def change
    add_column :articles, :noprivate, :boolean
  end
end
