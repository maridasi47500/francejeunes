class CreateCities < ActiveRecord::Migration[6.0]
  def change
    create_table :countries do |t|
      t.string :name
    end
    create_table :cities do |t|
      t.string :name
    end
  end
end
