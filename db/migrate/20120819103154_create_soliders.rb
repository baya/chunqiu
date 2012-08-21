class CreateSoliders < ActiveRecord::Migration
  def change
    create_table :soliders do |t|
      t.integer :kind
      t.integer :city_id

      t.timestamps
    end
  end
end
