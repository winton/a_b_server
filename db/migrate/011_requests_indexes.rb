class RequestsIndexes < ActiveRecord::Migration
  def self.up
    add_index :requests, :identifier
    add_index :requests, :ip
  end

  def self.down
    remove_index :requests, :identifier
    remove_index :requests, :ip
  end
end
