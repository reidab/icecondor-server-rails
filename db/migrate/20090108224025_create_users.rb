class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) do end
    create_table(:openidentities) do |t|
      t.column :url, :string
      t.column :user_id, :integer
    end
  end

  def self.down
    drop_table(:users)
    drop_table(:openidentities)
  end
end
