class CreateMessage < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.integer :sender_id
      t.integer :member_id
      t.text :content
      t.timestamps
    end
    create_table :dedicaces do |t|
      t.integer :sender_id
      t.integer :member_id
      t.text :content
      t.timestamps
    end
  end
end
