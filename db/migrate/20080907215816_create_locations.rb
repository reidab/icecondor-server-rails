class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table "locations", :force => true do |t|
      t.column "guid", :string
      t.column "time", :timestamp
      t.column "geom", :point, :null=>false, :srid => 123, :with_z => true
      t.timestamps
    end

    add_index "locations", "geom", :spatial=>true
  end

  def self.down
    drop_table :locations
  end
end
