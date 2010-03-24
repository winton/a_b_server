class Ips < ActiveRecord::Migration
  def self.up
    create_table :ips do |t|
      t.string :ip
      t.integer :count, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :ips
  end
end
