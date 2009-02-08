class AddStatusToUsers < ActiveRecord::Migration
  def self.up
   add_column :users, :access_status, :string
   User.all.each do |user|
     user.update_attribute :access_status, "private"
   end
  end

  def self.down
    remove_column :users, :access_status
  end
end
