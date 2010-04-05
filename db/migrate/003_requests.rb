class Requests < ActiveRecord::Migration
  def self.up
    create_table :requests do |t|
      t.string :identifier
      t.string :ip
      t.integer :visits, :default => 0
      t.integer :conversions, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :requests
  end
end
