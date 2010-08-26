class CreateFences < ActiveRecord::Migration
  def self.up
    create_table "fences" do |t|
      t.column "geom", :polygon, :null=>false, :srid => 4326, :with_z => true
      t.timestamps
    end

  end

  def self.down
    drop_table :fences
  end
end
