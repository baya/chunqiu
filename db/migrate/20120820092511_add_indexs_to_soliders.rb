class AddIndexsToSoliders < ActiveRecord::Migration
  def change
    add_index :soliders, :city_id
    add_index :soliders, :status
    add_index :soliders, [:status, :kind, :city_id]
  end
end
