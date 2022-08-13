class CreateWebeauties < ActiveRecord::Migration[6.0]
  def change
    create_table :webeauties do |t|
      t.integer :beautymember_id
      t.integer :member_id
      t.integer :note
      t.timestamps
    end
  end
end
