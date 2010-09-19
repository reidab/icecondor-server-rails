class AddTriggeredAtAndActiveToTriggers < ActiveRecord::Migration
  def self.up
    add_column :triggers, :triggered_at, :datetime
    add_column :triggers, :active, :boolean
  end

  def self.down
    remove_column :triggers, :triggered_at, :datetime
    remove_column :triggers, :active, :boolean
  end
end
