class MigrateLocationsToUsers < ActiveRecord::Migration
  def self.up
    add_column :locations, :user_id, :integer
    Location.all.each do |l|
      user = User.find(:first, :conditions => {:guid => l.guid})
      unless user
        user = User.create({:guid => l.guid})
      end
      l.update_attribute :user_id, user.id
    end
  end

  def self.down
  end
end
