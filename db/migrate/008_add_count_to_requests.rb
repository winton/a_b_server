class AddCountToRequests < ActiveRecord::Migration
  def self.up
    add_column :requests, :count, :integer, :default => 0
  end

  def self.down
    remove_column :requests, :count
  end
end
