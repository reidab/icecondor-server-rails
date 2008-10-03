class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table "locations", :force => true do |t|
      t.column "guid", :string
      t.column "time", :timestamp
      t.column "geom", :point, :null=>false, :srid => 4326, :with_z => true
      t.timestamps
    end

    if Location.connection.adapter_name != "MySQL"
      add_index "locations", "geom", :spatial=>true
    end
  end

  def self.down
    drop_table :locations
  end
end
