class ChangeFoodGoldToFloat < ActiveRecord::Migration
  def up
    change_column :cities, :food, :float
  end

  def down
    change_column :cities, :food, :integer
  end
end
