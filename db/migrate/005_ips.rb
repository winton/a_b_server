class Ips < ActiveRecord::Migration
  def self.up
    create_table :ips do |t|
      t.string :ip
      t.date :date
      t.integer :count, :default => 0
    end
  end

  def self.down
    drop_table :ips
  end
end
