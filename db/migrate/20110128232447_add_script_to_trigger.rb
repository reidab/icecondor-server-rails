class AddScriptToTrigger < ActiveRecord::Migration
  def self.up
    add_column :triggers, :script_id, :integer
  end

  def self.down
    remove_column :triggers, :script_id
  end
end
