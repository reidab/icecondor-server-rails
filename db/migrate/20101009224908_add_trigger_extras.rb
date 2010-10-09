class AddTriggerExtras < ActiveRecord::Migration
  def self.up
    add_column :triggers, :fsq_name, :string
    add_column :triggers, :fsq_shout, :string
  end

  def self.down
    remove_column :triggers, :fsq_name
    remove_column :triggers, :fsq_shout
  end
end
