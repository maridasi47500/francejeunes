class CreateDepartements < ActiveRecord::Migration[6.0]
  def change
    create_table :departements do |t|
      t.string :name
      t.integer :no
      t.timestamps
    end
    add_column :members, :departement_id, :integer
    add_column :members, :couple, :string
  end
end
