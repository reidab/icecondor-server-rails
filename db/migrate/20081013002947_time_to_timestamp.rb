class TimeToTimestamp < ActiveRecord::Migration
  def self.up
    rename_column :locations, :time, :timestamp
  end

  def self.down
    rename_column :locations, :timestamp, :time
  end
end
