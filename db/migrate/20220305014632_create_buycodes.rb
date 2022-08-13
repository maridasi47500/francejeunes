class CreateBuycodes < ActiveRecord::Migration[6.0]
  def change
    create_table :buycodes do |t|
      t.string :email
      t.string :cvc
      t.date :ccexp
      t.string :ccname
      t.integer :cardnumber
      t.float :price
      t.integer :member_id
      t.boolean :rememberemail
      t.timestamps
    end
  end
end
