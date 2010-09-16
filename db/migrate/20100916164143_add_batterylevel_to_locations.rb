class AddBatterylevelToLocations < ActiveRecord::Migration
  def self.up
    add_column :locations, :batterylevel, :integer
  end

  def self.down
    remove_column :locations, :batterylevel
  end
end
