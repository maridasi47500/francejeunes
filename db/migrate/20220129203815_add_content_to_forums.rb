class AddContentToForums < ActiveRecord::Migration[6.0]
  def change
    add_column :forums, :content, :text
    add_column :forums, :user_id, :integer
  end
end
