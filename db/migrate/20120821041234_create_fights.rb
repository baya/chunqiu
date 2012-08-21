class CreateFights < ActiveRecord::Migration
  def change
    create_table :fights do |t|
      t.integer :origin_city_id
      t.integer :target_city_id
      t.integer :status

      t.timestamps
    end
  end
end
