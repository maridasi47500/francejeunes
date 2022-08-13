class AddNbToCategories < ActiveRecord::Migration[6.0]
  def change
    add_column :categories, :nb, :integer
    add_column :categories, :url, :string
  end
end
