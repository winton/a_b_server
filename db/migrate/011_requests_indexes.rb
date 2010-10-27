class RequestsIndexes < ActiveRecord::Migration
  def self.up
    add_index :requests, :identifier
    add_index :requests, :ip
  end

  def self.down
    drop_table :requests_indexes
  end
end
