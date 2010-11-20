class MoreIndexes < ActiveRecord::Migration
  def self.up
    add_index :categories, :name
    add_index :envs, :name
    add_index :sites, :name
    add_index :users, :token
  end

  def self.down
    remove_index :categories, :name
    remove_index :envs, :name
    remove_index :sites, :name
    remove_index :users, :token
  end
end