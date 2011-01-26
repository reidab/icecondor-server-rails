class AddScriptName < ActiveRecord::Migration
  def self.up
    add_column :scripts, :name, :string
  end

  def self.down
    remove_column :scripts, :name
  end
end
