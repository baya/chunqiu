class AddStatusToSoliders < ActiveRecord::Migration
  def change
    add_column :soliders, :status, :integer, :default => 1
  end
end
