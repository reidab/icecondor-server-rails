class MigrateLocationsToUsers < ActiveRecord::Migration
  def self.up
    add_column :locations, :user_id, :integer
    puts "processing #{Location.count}"; count = 0
    Location.all.each do |l|
      openid = Openidentity.find(:first, :conditions => {:url => l.guid})
      if openid
        user = openid.user
      else
        user = User.create()
        Openidentity.create({:user => user, :url => l.guid})
      end
      l.update_attribute :user_id, user.id
      puts "finished #{count += 1}"
    end
  end

  def self.down
  end
end
