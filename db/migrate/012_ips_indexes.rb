class IpsIndexes < ActiveRecord::Migration
  def self.up
    add_index :ips, :date
  end

  def self.down
    remove_index :ips, :date
  end
end
