class AddIndexsToCities < ActiveRecord::Migration
  def change
    add_index :cities, [:capital, :user_id]
    add_index :cities, :capital
    add_index :cities, :user_id
  end
end
