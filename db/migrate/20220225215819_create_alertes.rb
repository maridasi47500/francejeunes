class CreateAlertes < ActiveRecord::Migration[6.0]
  def change
    create_table :alerts do |t|
      t.integer :member_id
      t.boolean :article
      t.boolean :musique
      t.boolean :forum
      t.boolean :image
      t.boolean :rencontres
      t.text :content
      t.timestamps
    end
  end
end
