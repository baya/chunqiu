class AddIndexsToSoliderQueues < ActiveRecord::Migration
  def change
    add_index :solider_queues, :city_id
    add_index :solider_queues, [:city_id, :status]
  end
end
