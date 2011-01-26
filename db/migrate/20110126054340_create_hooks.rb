class CreateHooks < ActiveRecord::Migration
  def self.up
    create_table :hooks do |t|
      t.integer :script_id
      t.string :verb
      t.string :target_id
      t.string :target_type

      t.timestamps
    end
  end

  def self.down
    drop_table :hooks
  end
end
