class MigrateLocationsToUsers < ActiveRecord::Migration
  def self.up
    add_column :locations, :user_id, :integer
    Location.all.each do |l|
      user = Openidentity.find(:first, :conditions => {:url => l.guid})
      unless user
        user = User.create()
        Openidentity.create({:user => user, :url => l.guid})
      end
      l.update_attribute :user_id, user.id
    end
  end

  def self.down
  end
end
