class CreateScripts < ActiveRecord::Migration
  def self.up
    create_table :scripts do |t|
      t.integer :user_id
      t.string :code

      t.timestamps
    end
  end

  def self.down
    drop_table :scripts
  end
end
