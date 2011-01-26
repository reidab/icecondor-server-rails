class CreateGeoServices < ActiveRecord::Migration
  def self.up
    create_table :geo_services do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :geo_services
  end
end
