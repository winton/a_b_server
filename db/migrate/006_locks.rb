class Locks < ActiveRecord::Migration
  def self.up
    create_table :locks do |t|
      t.string :name
      t.integer :start
      t.integer :end
      t.string :error, :limit => 2048
      t.datetime :failed_at
      t.timestamps
    end
  end

  def self.down
    drop_table :locks
  end
end
