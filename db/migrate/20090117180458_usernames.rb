class Usernames < ActiveRecord::Migration
  def self.up
    add_column :users, :username, :string
    User.all.each do |user|
      openid = user.openidentities.first
      puts "#{user} = #{openid}"
      user.update_attribute :username, Openidentity.generate_username(openid.url) if openid
    end
  end

  def self.down
    remove_column :users, :username
  end
end
