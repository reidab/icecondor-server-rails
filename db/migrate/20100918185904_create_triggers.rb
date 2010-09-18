class CreateTriggers < ActiveRecord::Migration
  def self.up
    create_table "triggers" do |t|
      t.integer :user_id
      t.integer :fence_id
      t.string :name
      t.string :action
      t.string :extra
      t.string :webhook
      t.timestamps
    end
  end

  def self.down
    drop_table :triggers
  end
end
