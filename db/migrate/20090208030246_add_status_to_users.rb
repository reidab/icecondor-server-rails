class AddStatusToUsers < ActiveRecord::Migration
  def self.up
   add_column :users, :access_status, :string
  end

  def self.down
    remove_column :users, :access_status
  end
end
