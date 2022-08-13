class CreateVuearticles < ActiveRecord::Migration[6.0]
  def change
    create_table :vuearticles do |t|
      t.integer :article_id
      t.timestamps
    end
  end
end
