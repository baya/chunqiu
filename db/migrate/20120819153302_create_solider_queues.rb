class CreateSoliderQueues < ActiveRecord::Migration
  def change
    create_table :solider_queues do |t|
      t.integer :city_id
      t.integer :solider_num
      t.integer :solider_kind
      t.integer :status,          :default => 0     

      t.timestamps
    end
  end
end
