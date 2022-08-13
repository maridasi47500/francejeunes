class CreateRubriqueimages < ActiveRecord::Migration[6.0]
  def change
    create_table :rubriqueimages do |t|
      t.string :name
      t.string :image
      t.string :url
      t.timestamps
    end
    create_table :sousrubimages do |t|
      t.integer :rubriqueimage_id
      t.string :name
      t.string :image
      t.string :url
      t.timestamps
    end
    create_table :images do |t|
      t.integer :sousrubimage_id
      t.string :title
      t.string :image
      t.integer :member_id
      t.string :url
      t.timestamps
    end
  end
end
