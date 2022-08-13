class CreateVuesongs < ActiveRecord::Migration[6.0]
  def change
    create_table :vuesongs do |t|
      t.integer :member_id
      t.integer :song_id
      t.timestamps
    end
  end
end
