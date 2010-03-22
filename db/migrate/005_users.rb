class Users < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.integer :identifier
      t.integer :limit_per_minute
    end
  end

  def self.down
    drop_table :users
  end
end
