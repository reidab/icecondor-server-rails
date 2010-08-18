class AddTimesToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :created_at, :datetime
    add_column :users, :updated_at, :datetime
    add_column :openidentities, :created_at, :datetime
    add_column :openidentities, :updated_at, :datetime
  end

  def self.down
    remove_column :users, :created_at
    remove_column :users, :updated_at
    remove_column :openidentities, :created_at
    remove_column :openidentities, :updated_at
  end
end
