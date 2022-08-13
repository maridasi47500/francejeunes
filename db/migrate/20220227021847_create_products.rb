class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :image
      t.string :name
      t.time :dispo
      t.string :price
    end
  end
end
