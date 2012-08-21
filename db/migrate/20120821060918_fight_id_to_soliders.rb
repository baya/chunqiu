class FightIdToSoliders < ActiveRecord::Migration
  def up
    add_column :soliders, :fight_id, :integer
  end

  def down
    remove_column :soliders, :fight_id
  end
  
end
