class CreateVuefiches < ActiveRecord::Migration[6.0]
  def change
    create_table :vuefiches do |t|
      t.integer :vuemember_id
      t.integer :member_id
      t.timestamps
    end
  end
end
