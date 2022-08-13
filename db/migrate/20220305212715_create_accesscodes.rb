class CreateAccesscodes < ActiveRecord::Migration[6.0]
  def change
    create_table :accesscodes do |t|
      t.string :code
      t.integer :member_id
      t.integer :buycode_id
    end
  end
end
