class Usernames < ActiveRecord::Migration
  def self.up
    add_column :users, :username, :string
    User.all.each do |user|
        openid = user.openidentities.first
        if openid
          username = Openidentity.generate_username(openid.url) 
          puts "user #{user.id} , openid #{openid.url}, username #{username}"
          user.update_attribute :username, username
        end
    end
  end

  def self.down
    remove_column :users, :username
  end
end
