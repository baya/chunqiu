class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.integer :human
      t.integer :food
      t.integer :gold
      t.float :tax_rate
      t.integer :pos_x
      t.integer :pos_y
      t.string :name
      t.boolean :capital
      t.integer :user_id

      t.timestamps
    end
  end
end
