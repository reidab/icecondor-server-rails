class W3cLocationFields < ActiveRecord::Migration
  def self.up
    add_column :locations, :accuracy, :float
    add_column :locations, :altitude_accuracy, :float
    add_column :locations, :heading, :float
    add_column :locations, :velocity, :float
  end

  def self.down
    remove_column :locations, :accuracy
    remove_column :locations, :altitude_accuracy
    remove_column :locations, :heading
    remove_column :locations, :velocity
  end
end
