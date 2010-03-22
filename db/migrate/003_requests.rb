class Requests < ActiveRecord::Migration
  def self.up
    create_table :requests do |t|
      t.string :data, :limit => 1024
      t.string :identifier
      t.string :ip
      t.boolean :processed, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :requests
  end
end
